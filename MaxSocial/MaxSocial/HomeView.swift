//
//  HomeView.swift
//  MaxSocial
//
//  Created by StudentAM on 5/1/24.
//

import SwiftUI

struct Posts {
    var username: String
    var content: String
}

struct HomeView: View {
    
    @State var users: [User]
    
    @State private var text: String = ""
    
    @State private var usernameView: String = ""
    @State private var userFound: Bool = false
    
    @State var loggedIn: [User]
    
    @State private var posts: [Posts] = [
        Posts(username:"HelpyForNewbs", content:"Hello! Welcome to MaxSocial! I can be your first follower as well!"),
        Posts(username:"HelpyForNewbs" , content:"Fun Fact: Did you know that the brain is constantly eating itself? This is happening to remove any dangerous cells or debris to protect itself. It can also heal itself.")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        // Activates the AccountView when the when the user presses on a post (as long as it's not a comment or a share button).
                        NavigationLink(destination: AccountView(loggedIn: loggedIn, users: users, userViewer: loggedIn[0].username, viewedUser: usernameView), isActive: $userFound) {
                            EmptyView()
                        }
                        // Loops through the posts array that creates more when new posts are made.
                        ForEach(posts.indices, id: \.self) { index in
                            VStack {
                                Button(action: {
                                    // Calls the function to look for the info of the user the logged on user clicked on.
                                    lookForInfo(viewingUser: posts[index].username)
                                }, label: {
                                    // Makes new posts.
                                    NewPostView(username: posts[index].username, postText: posts[index].content)
                                })
                                HStack {
                                    // These buttons do nothing. Nothing at all.
                                    Button(action: {
                                        print("Commenting post")
                                    }, label: {
                                        Text("Comment")
                                    })
                                    Button(action: {
                                        print("Sharing post")
                                    }, label: {
                                        Text("Share")
                                    })
                                }
                                .padding(.top, 1)
                            }
                            .padding()
                        }
                    }
                }
                .frame(width: 390, height: 610)
                VStack {
                    Text("MaxSocial")
                        .padding(.leading, -182)
                        .padding(.bottom, -10)
                    HStack {
                        // Allows the user to type a message and post it in the HomeView.
                        TextField("Type a Message...", text: $text)
                            .border(.gray)
                        
                        // This button allows the user to post what they have wrote down.
                        Button(action: {
                            posts.append(Posts(username: loggedIn[0].username, content: text))
                            text = ""
                        }, label: {
                            Text("Post")
                        })
                        .padding(5)
                        .background(.blue)
                        .foregroundColor(.white)
                        .bold(true)
                        .cornerRadius(30)
                    }
                    .padding(.trailing, 15)
                    .padding(.leading, 15)
                }
            }
        }
        .foregroundColor(.black)
    }
    // This function is activated to collect the info of the user that has been clicked on.
    func lookForInfo (viewingUser: String) {
        for user in users {
            if user.username == viewingUser {
                usernameView = viewingUser
                print(viewingUser)
                userFound = true
            }
        }
    }
}

#Preview {
    HomeView(users: [User(username: "HelpyForNewbs", password: "GuessCanI?", firstName: "Michael", lastName: "Vincent", birthDate: "02/21/1998", email: "MichelleVwinner@gmail.com", bio: "I am an A.I. (Not really). I try to help out with newcomers with MaxSocial and make them feel welcomed!", followed: 5, followers: []), User(username: "Dummy", password: "GuessCanI?", firstName: "Jonas", lastName: "Kelly", birthDate: "02/21/1998", email: "dummEmail@gmail.com", bio: "Dummy info, not of this is real nor A.I. Just on your imaginatiooon", followed: 5, followers: [])], loggedIn: [User(username: "HelpyForNewbs", password: "GuessCanI?", firstName: "Michael", lastName: "Vincent", birthDate: "02/21/1998", email: "MichelleVwinner@gmail.com", bio: "I am an A.I. (Not really). I try to help out with newcomers with MaxSocial and make them feel welcomed!", followed: 5, followers: [])])
}
