//
//  CreateView.swift
//  MaxSocial
//
//  Created by StudentAM on 4/30/24.
//

import SwiftUI

struct CreateView: View {
    
    @State var users: [User]
    @State var loggedIn: [User]
    
    @State private var termsConditions: Bool = false
    @State private var userAgreement: Bool = false
    
    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthdate: String = ""
    @State private var email: String = ""
    
    @State private var infoAccepted: Bool = false
    @State private var emailAccepted: Bool = false
    @State private var birthdateAccepted: Bool = false
    
    var body: some View {
        
        NavigationView {
            if !termsConditions {
                // This VStack contains the info of every information that is required.
                VStack {
                    Text("Create An Account")
                        .font(.system(size: 23))
                    
                    TextField("Username", text: $newUsername)
                        .border(Color.gray)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    TextField("Password", text: $newPassword)
                        .border(Color.gray)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    VStack {
                        Text("Name: ")
                            .font(.system(size: 21))
                        
                        HStack {
                            TextField("First", text: $firstName)
                                .border(Color.gray)
                                .padding(.leading, 20)
                            TextField("Last", text: $lastName)
                                .border(Color.gray)
                                .padding(.trailing, 20)
                        }
                        
//                        DatePicker(selection: $birthdate, in: ...Date.now, displayedComponents: .date) {
//                            Text("Enter your birthdate")
//                        }
//                        .padding()
                        
                        TextField("dd/mm/yyyy", text: $birthdate)
                            .border(Color.gray)
                            .padding(.leading, 145)
                            .padding(.trailing, 145)
                            .multilineTextAlignment(.center)
                        
                        TextField("Sample@gmail.com", text: $email)
                            .border(Color.gray)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                    }
                    HStack {
                        // Allows the user to go back to the login view.
                        NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), label: {
                            Text("Back")
                                .font(.system(size: 20))
                        })
                        .padding(17)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        
                        Button(action: {
                            infoCheck()
                        }, label: {
                            Text("Create")
                                .font(.system(size: 20))
                        })
                        .padding(17)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    }
                }
            } else {
                VStack {
                    // Creates this part of the view as a part of the Terms and Conditions.
                    Text("I will not cause any sort of cyberbullying, harrassment, sexual harrassment, verbal and psychological abuse, assault, sexual assault, doxxing, hacking, and other illegal activities on this platform")
                        .padding()
                    
                    Text("I understand the consequences being warned for the first and second time should be enough to get me to stop, otherwise I could be banned temporarly or permanently.")
                        .padding()
                    
                    Toggle("I, \(firstName) \(lastName), agree to the Terms and Conditions", isOn: $userAgreement)
                        .toggleStyle(SwitchToggleStyle())
                        .padding()
                    
                    // Sends the user to go into the TabPage to access the HomeView, RouletteView, and AccountView.
                    NavigationLink(destination: TabPage(users: users, loggedIn: loggedIn).navigationBarBackButtonHidden(true), isActive: $userAgreement) {
                        EmptyView()
                    }
                }
            }
        }
    }
    
    // Made to check if the user's info can go through the requirements the social media app wants. Adds the user info in the loggedIn array and users array.
    func infoCheck() {
        
        if newUsername.count < 8 && newPassword.count < 8 && firstName.count < 2 && lastName.count < 2 {
            
        } else {
            infoAccepted = true
            for char in email {
                if char == "@" {
                    emailAccepted = true
                }
            }
            var forwardSlashes: Int = 0
            for char in birthdate {
                if char == "/" {
                    forwardSlashes += 1
                }
            }
            print(birthdate.count)
            if forwardSlashes == 2 && birthdate.count == 10 {
                
                birthdateAccepted = true
                
                if infoAccepted && emailAccepted && birthdateAccepted {
                    
                    var newUser: User = User(username: newUsername, password: newPassword, firstName: firstName, lastName: lastName, birthDate: birthdate, email: email, bio: "", followed: 0, followers: [])
                    
                    users.append(newUser)
                    loggedIn.append(newUser)
                    
                    print(loggedIn)
                    
                    termsConditions = true
                }
            }
        }
    }
}

#Preview {
    CreateView(users: [], loggedIn: [])
}
