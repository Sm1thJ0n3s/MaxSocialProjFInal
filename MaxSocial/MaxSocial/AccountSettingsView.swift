//
//  AccountSettingsView.swift
//  MaxSocial
//
//  Created by StudentAM on 5/1/24.
//

import SwiftUI

struct AccountSettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var userInfo: [User]
    
    @State var selectedPrivacy: Int = 0
    let privacyOptions = ["Open", "Followers Only", "Closed"]
    
    @State private var newUsername: String = ""
    @State private var new1stName: String = ""
    @State private var newLastName: String = ""
    @State private var newEmail: String = ""
    @State private var newBiograph: String = ""
    
    @State private var saveChangesClicked: Bool = false
    
    @State private var newEmailAccepted: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Image("profilePicAccView")
                    VStack {
                        // Allows users to make a new username.
                        TextField("Username", text: $newUsername)
                            .frame(width: 170)
                            .border(.black)
                            .multilineTextAlignment(.center)
                        HStack {
                            // Allows users to enter their first name they'd perfer or have changed.
                            TextField("First", text: $new1stName)
                                .frame(width: 80)
                                .border(.black)
                                .multilineTextAlignment(.center)
                            
                            // Allows users to enter their last name they have taken due to love life or family issue reasons (mainly).
                            TextField("Last", text: $newLastName)
                                .frame(width: 80)
                                .border(.black)
                                .multilineTextAlignment(.center)
                        }
                        // Allows users to put in their new email.
                        TextField("Email", text: $newEmail)
                            .frame(width: 170)
                            .border(.black)
                    }
                    VStack {
                        // This button tells the view that the user is wanting to save their changes but we need to ensure that the user is happy with these changes.
                        Button(action: {
                            print("Your changes will be saved soon")
                            saveChangesClicked = true
                        }, label: {
                            Image("saveIcon")
                        })
                        // This button allows the user to go back to the AccountView if they don't want to save any changes.
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("cancelIcon")
                        })
                    }
                }
                // The new biograph of the user is allowed to enter in.
                Text("Bio: ")
                TextEditor(text: $newBiograph)
                    .frame(width: 260, height: 150)
                    .border(.black)
                HStack {
                    // This does nothing. Just a cosmetic.
                    Text("Privacy: ")
                        .padding(.leading, 60)
                    Picker(selection: $selectedPrivacy, label: Text("")) {
                        ForEach(privacyOptions.indices, id:\.self) { index in
                            Text(privacyOptions[index])
                        }
                    }
                    .padding(-70)
                    .padding(.leading, -140)
                    .pickerStyle(.wheel)
                }
            }
            // Activates when you press the wrench to save the changes the user made.
            if saveChangesClicked {
                VStack {
                    // It'll ask this question if you want to keep the changes the way they are.
                    Text("Would you like to save the changes you are happy with?")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .multilineTextAlignment(.center)
                    HStack {
                        // If they pressed yes, their info is save and they are sent back to the AccountView.
                        Button(action: {
                            saveInfo()
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Yes")
                                .foregroundColor(.blue)
                                .font(.system(size: 19))
                                .bold(true)
                        })
                        .padding(.trailing, 50)
                        // If they click no, this stuff will disappear and the user will be allowed to continue making changes to what they put.
                        Button(action: {
                            saveChangesClicked = false
                        }, label: {
                            Text("No")
                                .foregroundColor(.blue)
                                .font(.system(size: 19))
                                .bold(true)
                        })
                        .padding(.leading, 50)
                    }
                    .padding(7)
                }
                .padding(20)
                .background(.black)
                .cornerRadius(10)
            }
        }
    }
    // This function is activated when the user wants to save the changes they are happy with. Even save old info the user doesn't change.
    func saveInfo () {
        // The requirements must be met that this social media app requires from the user to put in. This part checks on the new username, 1stName and lastName.
        if (newUsername.count < 8 && newUsername.count > 0) && (new1stName.count < 2 && new1stName.count > 0) && (newLastName.count < 2 && newLastName.count > 0) {
            print("Requirements are not met! Make sure your username is 8 or more characters and you full name to be greater than 1 charcter.")
        } else {
            // Checks on the email
            for char in newEmail {
                if char == "@" {
                    newEmailAccepted = true
                }
            }
            if newEmail.count == 0 {
                newEmailAccepted = true
            }
            // After the email is accepted, the info is accepted and changed IF it doesn't equal to 0.
            if newEmailAccepted {
                for i in userInfo.indices {
                    if newUsername.count != 0 {
                        userInfo[i].username = newUsername
                        print(userInfo[i].username)
                    }
                    if new1stName.count != 0 {
                        userInfo[i].firstName = new1stName
                        print(userInfo[i].firstName)
                    }
                    if newLastName.count != 0 {
                        userInfo[i].lastName = newLastName
                        print(userInfo[i].lastName)
                    }
                    if newEmail.count != 0 {
                        userInfo[i].email = newEmail
                        print(userInfo[i].email)
                    }
                    if newBiograph.count != 0 {
                        userInfo[i].bio = newBiograph
                        print(userInfo[i].bio)
                    }
                    print(userInfo)
                }
            }
        }
    }
}

#Preview {
    AccountSettingsView(userInfo: [User(username: "ImJustADummy", password: "DummyPassword", firstName: "William", lastName: "Albrekston", birthDate: "02/12/2004", email: "dummymailing@gmail.com", bio: "Lorem Ipsum is a way to get more dummy info for designing reasons with texts.", followed: 7, followers: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"])])
}
