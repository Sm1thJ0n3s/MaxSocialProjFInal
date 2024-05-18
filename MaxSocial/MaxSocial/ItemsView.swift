//
//  ItemsView.swift
//  MaxSocial
//
//  Created by StudentAM on 5/14/24.
//

import SwiftUI

struct ItemsView: View {
    
    var inventory: [String]
    
    var body: some View {
        HStack {
            ForEach(inventory.indices, id: \.self) { index in
                if inventory[index] == "Cigarette" {
                    Image("Cigarette")
                } else if inventory[index] == "Beer" {
                    Image("Beer")
                } else if inventory[index] == "Spy Glass" {
                    Image("SpyGlass")
                } else if inventory[index] == "Cell Phone" {
                    Image("Phone")
                } else if inventory[index] == "Hand Saw" {
                    Image("HandSaw")
                }
            }
        }
    }
}

#Preview {
    ItemsView(inventory: ["Beer", "Hand Saw", "Cell Phone", "Spy Glass", "Cigarette"])
}
