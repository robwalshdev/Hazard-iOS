//
//  ProfileView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 23/03/2021.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var isLoggedOut = false
    @State var userHazards: [Hazard] = []
    
    let placemark: String
        
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    
                    // Background + Sign out button
                    HStack{
                        Text("Profile")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .padding(.bottom, 50)

                        Spacer()
                        
                        Button(action: {
                            UserAuth().logout()
                            isLoggedOut.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "powersleep")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding(.bottom, 50)
                            .shadow(color: Color.white.opacity(0.2), radius: 10, x: 5, y: 5)
                            .padding()
                        }).fullScreenCover(isPresented: $isLoggedOut, content: {
                            ContentView()
                        })
                    }
                    .frame(width: screen.width, height: screen.width * 0.9)
                    .background(Color.blue)
                    .offset(y: -screen.width * 0.2)
                    
                    // User details
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        Text(UserAuth().getUsernameFromToken())
                            .font(.title)
                            .bold()
                        
                        // Badges / Rewards / Stats
                        HStack {
                            Text(placemark)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color("LightBlue"))
                                .cornerRadius(5.0)
                            
                            Text("\(userHazards.count) hazards")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .cornerRadius(5.0)
                            
                            Text("Other")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .cornerRadius(5.0)
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        HStack {
                            Text(UserAuth().getExpireFromToken())
                                .font(.caption)
                                .foregroundColor(.gray )
                                .padding(.vertical)
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(width: screen.width * 0.9, height: screen.width / 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 5, y: 10)
                    .offset(x: 0, y: screen.width / 3)
                }
                
                // Users Hazards
                
                Spacer()
                    .frame(height: screen.width / 5)
                
                HStack {
                    Text("My hazards")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                
                ForEach(userHazards, id:\.hazardId) { hazard in
                    HazardCard(hazard: hazard, showTabBar: .constant(true), hazards: $userHazards, isUserHazard: true)
                }
                
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundColor(Color.gray.opacity(0.05))
                    .frame(width: screen.width / 1.1, height: 80, alignment: .center)
                    .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Spacer()
            }
            
            .onAppear {
                getHazardsByUser()
            }
        }.ignoresSafeArea()
    }
    
    func getHazardsByUser() {
        HazardApi().getHazardsByUser { (userHazards) in
            self.userHazards = userHazards
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(placemark: "Galway")
    }
}
