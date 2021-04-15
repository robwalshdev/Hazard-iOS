//
//  TabNavigationView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 19/03/2021.
//

import SwiftUI
import MapKit

struct TabNavigationView: View {
    
    @State private var showTabBar: Bool = true
    @State private var selectedIndex: Int = 0
    @State var showModal = false
    
    let tabBarImageNames = ["car.2", "paperplane.fill", "heart"]
    
    let userLocation: CLLocationCoordinate2D
    let placemark: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Spacer().fullScreenCover(isPresented: $showModal, content: {
                    ReportView(userLocation: userLocation, showView: $showModal)
                })
                
                switch selectedIndex {
                case 0:
                    HomeView(userLocation: userLocation, placemark: placemark, showTabBar: $showTabBar)
                default:
                    ProfileView(placemark: placemark)
                }
            }
            .onAppear {
                HazardApi().setQueryDefaults(time: 4, distance: 20, lat: userLocation.latitude, lon: userLocation.longitude)
            }
            
            Rectangle()
                .frame(width: screen.width, height: 20, alignment: .center)
                .background(Color.blue.opacity(0.3))
                .blur(radius: 150)
                .ignoresSafeArea(.all)
            
            if showTabBar {
                HStack {
                    ForEach(0..<3) { num in
                        Button(action: {
                            if num == 1 {
                                showModal.toggle()
                                return
                            }
                            
                            selectedIndex = num
                        }, label: {
                            Spacer()
                                .frame(width: 30)
                            
                            if num == 1 {
                                Image(systemName: tabBarImageNames[num])
                                    .foregroundColor(.blue)
                                    .font(.system(size: 40, weight: .bold))
                            } else {
                                Image(systemName: selectedIndex == num ? "\(tabBarImageNames[num]).fill" : tabBarImageNames[num])
                                    .foregroundColor(selectedIndex == num ? .black : Color.black.opacity(0.1))
                                    .font(.system(size: 22, weight: .bold))
                            }
                            Spacer()
                                .frame(width: 30)
                        })
                        .padding(.vertical, 10)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 5, y: 10)
                .padding(.horizontal, 20)
            }
            
        }
        .statusBar(hidden: true)
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView(userLocation: CLLocationCoordinate2D(), placemark: "Galway")
    }
}
