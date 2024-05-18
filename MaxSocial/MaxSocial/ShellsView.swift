//
//  ShellsView.swift
//  MaxSocial
//
//  Created by StudentAM on 5/10/24.
//

import SwiftUI

struct ShellsView: View {
    
    var minimum: Int
    var maximum: Int
    var shells: [Bool]
    
    var body: some View {
        
        HStack {
            // Creates a certain amount of shells from minimum to max. 4 shells in a row.
            ForEach(shells.indices, id: \.self) { index in
                if index >= minimum && index <= maximum {
                    if shells[index] {
                        // Created when the shell is Live (true).
                        Image("LiveShell")
                    } else {
                        // Created when the shell is Blank (false).
                        Image("BlankShell")
                    }
                }
            }
        }
    }
}

#Preview {
    ShellsView(minimum:0, maximum:3, shells: [false, false, true, false, true, true, true])
}
