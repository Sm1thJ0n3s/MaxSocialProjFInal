//
//  NewPostView.swift
//  MaxSocial
//
//  Created by StudentAM on 5/1/24.
//

import SwiftUI

struct NewPostView: View {
    var username: String
    var postText: String
    
    var body: some View {
        VStack {
            HStack {
                // Just a pic.
                Image("defaultProfilePic")
                    .padding(.leading, -170)
                
                // The username of the user that made the post.
                Text(username)
                    .padding(.leading, -110)
                    .padding(.top, -20)
            }
            
            // The content of what the user has put in.
            Text(postText)
                .padding(.leading, 35)
                .padding(.trailing, 10)
                .padding(.bottom, 0)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    NewPostView(username: "sgsgsgs", postText: "resdsgdfsgsdgarhdsfhsfgoifrhiugfhfuhf  hui hfiufh uis hfiughu shuhfuidhf uf hu hfifu dfh sdiu hui sdh gpa hdfiuzv hoj vzxj vnav ni vz  dig hadfiu gh v kj njzx bijxv nzixu bxzjk nzxiusd vbdfjh  n gjx b sbail")
}
