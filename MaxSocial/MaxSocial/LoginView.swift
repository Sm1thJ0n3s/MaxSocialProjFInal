//
//  ContentView.swift
//  MaxSocial
//
//  Created by StudentAM on 4/30/24.
//

import SwiftUI

struct User: Hashable {
    var username: String
    var password: String
    var firstName: String
    var lastName: String
    var birthDate: String
    var email:String
    var bio: String
    var followed: Int
    var followers: [String]
}

struct LoginView: View {
    
    @State var loggedIn: [User] = []
    
    @State private var displayView: Bool = false
    
    @State var users: [User] = [
        User(username: "HelpyForNewbs", password: "GuessCanI?", firstName: "Michael", lastName: "Vincent", birthDate: "02/21/1998", email: "MichelleVwinner@gmail.com", bio: "I am an A.I. (Not really). I try to help out with newcomers with MaxSocial and make them feel welcomed!", followed: 5, followers: [])
    ]
    
    @State private var usernameEmail: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("MaxSocial")
                    .font(.system(size: 40))
                    .bold(true)
                
                Text("Login")
                    .padding()
                    .font(.title)
                
                VStack {
                    // Created for users to put in their username or email.
                    Text("Username or Email:")
                    TextField("Sample", text: $usernameEmail)
                }
                
                VStack {
                    // Created for users to put in their password.
                    Text("Password:")
                    SecureField("Sample123!", text: $password)
                }
                // Made to allow to the user to create their own account.
                NavigationLink(destination: CreateView(users: users, loggedIn: loggedIn).navigationBarBackButtonHidden(true), label: {
                    Text("Create new account")
                        .font(.system(size: 13))
                        .underline()
                })
                // Created to check on the info the user has inputted in.
                Button(action: {
                    checkInfo()
                }, label: {
                    Text("Log In")
                        .font(.system(size: 24))
                })
                .padding(10)
                .bold(true)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                // Activated when the info the user puts in is correct for a user.
                NavigationLink(destination: TabPage(users: users, loggedIn: loggedIn).navigationBarBackButtonHidden(true), isActive: $displayView) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    func checkInfo () {
        for user in users {
            // Goes through the users array until the user's username/email and password is correct and adding the user's info into the loggedIn array.
            if (user.username == usernameEmail || user.email == usernameEmail) && user.password == password {
                
                loggedIn.append(user)
                print("user logged in" )
                print(loggedIn)
                displayView = true
            }
        }
    }
}

#Preview {
    LoginView()
}
