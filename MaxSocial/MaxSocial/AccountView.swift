//
//  AccountView.swift
//  MaxSocial
//
//  Created by StudentAM on 5/1/24.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var loggedIn: [User]
    @State var users: [User]
    @State var isLoggedIn: Bool = true
    var userViewer: String
    var viewedUser: String
    
    @State var accountChange: Bool = false
    @State var affectedInfo: [User] = []
    
    @State var logOutClicked: Bool = false
    @State var userLoggedOff: Bool = false
    
    @State private var followingUser: Bool = false
    @State private var userIndex: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // Allows the userViewer, viewing their own account, to make changes to their account (not really) in this other view.
                NavigationLink(destination: AccountSettingsView(userInfo: loggedIn).navigationBarBackButtonHidden(true), isActive: $accountChange) {
                }
                
                // When the user wants to log out, they are sent back to the LoginView (their account will be deleted sadly).
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $userLoggedOff) {
                    EmptyView()
                }
                ZStack {
                    // This is basically just the info of the viewedUser being shown, going through the users data.
                    ForEach(users.indices, id: \.self) { index in
                        VStack {
                            // if the username found in the users data is the same as the viewedUser, this IF statement activates.
                            if users[index].username == viewedUser{
                                HStack {
                                    Image("profilePicAccView")
                                        .padding(.trailing, viewedUser == userViewer ? 20 : 0)
                                    VStack {
                                        Text(viewedUser)
                                        HStack {
                                            // If the users are not the same, the follow/unfollow button appears
                                            if viewedUser != userViewer {
                                                // The follow button.
                                                if !users[index].followers.contains(userViewer) {
                                                    Button(action: {
                                                        users[index].followers.append(userViewer)
                                                        
                                                        print(users[index].followers)
                                                    }, label: {
                                                        Text("Follow")
                                                    })
                                                    .frame(width:80,height:25)
                                                    .foregroundColor(.white)
                                                    .background(viewedUser != userViewer ? .blue : .white)
                                                    .cornerRadius(50)
                                                } else {
                                                    // The unfollow button.
                                                    Button(action: {
                                                        userIndex = unfollowUser(userFollowers: users[index].followers)
                                                        print(users[index].followers)
                                                        
                                                        if followingUser {
                                                            users[index].followers.remove(at: userIndex)
                                                            followingUser = false
                                                        }
                                                    }, label: {
                                                        Text("Unfollow")
                                                    })
                                                    .frame(width:80,height:25)
                                                    .foregroundColor(.white)
                                                    .background(viewedUser != userViewer ? .red : .white)
                                                    .cornerRadius(50)
                                                }
                                            }
                                            // Shows the number of followers the viewedUser has.
                                            Text("\(users[index].followers.count) Followers")
                                        }
                                        // Shows the full name of the viewed User
                                        Text("\(users[index].firstName) \(users[index].lastName)")
                                            .padding(.leading, viewedUser == userViewer ? 4 : -88)
                                            .foregroundColor(.gray)
                                    }
                                    // If the viewedUser and userViewer are the same, then this button is shown.
                                    if viewedUser == userViewer {
                                        // Allows the user to make changes to their account with the AccountSettingsView (it really doesn't though).
                                        Button(action: {
                                            gettingInfo()
                                            accountChange = true
                                        }, label: {
                                            Image("SettingsGear")
                                        })
                                    }
                                }
                                if users[index].username == viewedUser {
                                    // The bio of the viewedUser.
                                    Text("\(viewedUser)'s Bio: ")
                                        .padding(.trailing, 130)
                                    
                                    // This is where the bio of the viewedUser is shown
                                    Text(users[index].bio)
                                        .padding(.leading, 43)
                                        .padding(.trailing, 25)
                                    
                                    // This is where the number of followed users the viewedUser has followed is shown.
                                    Text("\(users[index].followed) Followed")
                                        .padding()
                                        .padding(.leading, -167)
                                    
                                    if userViewer == viewedUser {
                                        // Being the user that is viewing your own account, you are allowed to click this button and log out of your account. Be warned, your account will be lost.
                                        Button(action:{
                                            logOutQuestion()
                                        }, label: {
                                            Text("Log Out")
                                                .foregroundColor(.blue)
                                        })
                                    }
                                }
                            }
                        }
                    }
                    // Activated when the user decided to go ahead and click on the log out button.
                    if logOutClicked {
                        VStack {
                            Text("Are you sure you want to log out?")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            HStack {
                                // Alolows the user to log out.
                                Button(action: {
                                    userIndex = userLoggedOut()
                                    
                                    if userIndex < 0 {
                                        print("User not found")
                                    } else {
                                        loggedIn.remove(at: userIndex)
                                        userLoggedOff = true
                                        print(loggedIn)
                                    }
                                }, label: {
                                    Text("Yes")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 19))
                                        .bold(true)
                                })
                                // Allows the user to say no, deactivating the question.
                                Button(action: {
                                    logOutClicked = false
                                }, label: {
                                    Text("No")
                                        .foregroundColor(.blue)
                                        .font(.system(size:19))
                                        .bold(true)
                                })
                            }
                            .padding()
                        }
                        .padding(20)
                        .background(.black)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    // To ask if the user that is viewing their own post if they do want to log out.
    func logOutQuestion () {
        logOutClicked = true
    }
    
    // Activated after the user answered "Yes" to the question, logging the user out.
    func userLoggedOut () -> Int {
        for i in loggedIn.indices {
            if loggedIn[i].username == viewedUser {
                return i
            }
        }
        return -1
    }
    
    // Activated to allow the user to unfollow the user that has been followed by the userViewer.
    func unfollowUser (userFollowers: [String]) -> Int {
        // A loop to look for the user that wants to unfollow the viewedUser's follower list.
            for i in userFollowers.indices {
                if userFollowers[i] == userViewer {
                    print(userFollowers[i])
                    print(i)
                        
                    followingUser = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                    }
                    return i
                }
            }
        print("Yoloooooooo")
        
        followingUser = false
        return 0
    }
    // Gets the info of the user. This is activated to make changes to their own account.
    func gettingInfo () {
        for user in loggedIn {
            if user.username == viewedUser {
                affectedInfo.append(user)
            }
        }
    }
}

#Preview {
    AccountView(loggedIn: [User(username: "ImJustADummy", password: "DummyPassword", firstName: "William", lastName: "Albrekston", birthDate: "02/12/2004", email: "dummymailing@gmail.com", bio: "Lorem Ipsum is a way to get more dummy info for designing reasons with texts.", followed: 7, followers: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]), User(username: "ImAnotherDummy", password: "DummyPassword", firstName: "Samuel", lastName: "Michelle", birthDate: "02/12/2004", email: "dummymailing@gmail.com", bio: "Lorem Ipsum is a way to get more dummy info for designing reasons with texts.", followed: 0, followers: ["One", "Two", "ImJustADummy", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"])], users: [User(username: "ImJustADummy", password: "DummyPassword", firstName: "William", lastName: "Albrekston", birthDate: "02/12/2004", email: "dummymailing@gmail.com", bio: "Lorem Ipsum is a way to get more dummy info for designing reasons with texts.", followed: 7, followers: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]), User(username: "ImAnotherDummy", password: "DummyPassword", firstName: "Samuel", lastName: "Michelle", birthDate: "02/12/2004", email: "dummymailing@gmail.com", bio: "Lorem Ipsum is a way to get more dummy info for designing reasons with texts.", followed: 0, followers: ["One", "Two", "ImJustADummy", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"])], userViewer: "ImJustADummy", viewedUser: "ImJustADummy")
}
