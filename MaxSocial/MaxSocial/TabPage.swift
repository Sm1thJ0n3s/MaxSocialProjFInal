//
//  TabPage.swift
//  MaxSocial
//
//  Created by StudentAM on 5/3/24.
//

import SwiftUI

struct TabPage: View {
    
    @State var users: [User]
    @State var loggedIn: [User]
    
    var body: some View {
        TabView {
            // Turns the page to the HomeView
            HomeView(users: users, loggedIn: loggedIn)
                .tabItem {
                    Image("PublicTab")
                }
            VStack{
                // Turns the page to the RouletteView
                RouletteView()
            }
                .tabItem {
                    Image("RouletteTab")
                }
            VStack{
                // Turns the page to the AccountView
                AccountView(loggedIn: loggedIn, users: users, userViewer: loggedIn[0].username, viewedUser: loggedIn[0].username)
            }
                .tabItem {
                    Image("accountTab")
                }
        }
    }
}

#Preview {
    TabPage(users: [User(username: "HelpyForNewbs", password: "GuessCanI?", firstName: "Michael", lastName: "Vincent", birthDate: "02/21/1998", email: "MichelleVwinner@gmail.com", bio: "I am an A.I. (Not really). I try to help out with newcomers with MaxSocial and make them feel welcomed!", followed: 5, followers: [])], loggedIn: [User(username: "HelpyForNewbs", password: "GuessCanI?", firstName: "Michael", lastName: "Vincent", birthDate: "02/21/1998", email: "MichelleVwinner@gmail.com", bio: "I am an A.I. (Not really). I try to help out with newcomers with MaxSocial and make them feel welcomed!", followed: 5, followers: [])])
}
