//
//  HealthPointsView.swift
//  MaxSocial
//
//  Created by StudentAM on 5/14/24.
//

import SwiftUI

struct HealthPointsView: View {
    
    var player: String
    var healthArray: [Bool]
    
    var body: some View {
        HStack {
            // This goes through the health of the player and the AI.
            ForEach (healthArray.indices, id: \.self) { index in
                // This is to see if this custom view is called to go through the Player's health (in an array) or the AI's health (in an array).
                if player == "Player" {
                    if healthArray[index] {
                        // If the health point is true, this image is created.
                        Image("PlayerHealthPoint")
                    } else {
                        // Else the health point is seen to be black.
                        Image("MissingHealthPoint")
                    }
                } else {
                    if healthArray[index] {
                        // If the health point is true, this image is created.
                        Image("AIHealthPoint")
                    } else {
                        // Else, the health point is blank, missing.
                        Image("MissingHealthPoint")
                    }
                }
            }
        }
    }
}

#Preview {
    HealthPointsView(player: "Player", healthArray: [true, true, false, false, false, false])
}
