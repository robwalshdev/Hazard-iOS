//
//  ProfileView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 23/03/2021.
//

import SwiftUI

struct ProfileView: View {
    @State private var isLoggedOut = false
    
    var body: some View {
        VStack {
            Button(action: {
                UserAuth().logout()
                isLoggedOut.toggle()
            }, label: {
                HStack {
                    Text("Sign out")
                        .font(.headline)
                        .bold()
                        
                    Image(systemName: "powersleep")
                        .foregroundColor(.white)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.bottom, 50)
                .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 5, y: 10)
            }).fullScreenCover(isPresented: $isLoggedOut, content: {
                ContentView()
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
