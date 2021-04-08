//
//  MainHazardCard.swift
//  Road Hazards
//
//  Created by Robert Walsh on 26/01/2021.
//

import SwiftUI
import MapKit

struct HeaderCard: View {
    let userLocation: CLLocationCoordinate2D
    let locationName: String
    let hazardCount: Int
    
    @Binding var distance: Double
    @Binding var timeFrom: Int
    
    @State var showMenu = false
    
    var body: some View {
        ZStack {
            ZStack (alignment: Alignment(horizontal: .center, vertical: .top)){
                ZStack {
                    MapView(latitude: userLocation.latitude, longitude: userLocation.longitude, delta: 0.2, showLocation: true, annotationLocations: [])
                        .cornerRadius(20)
                        .allowsHitTesting(false)
                }.frame(width: screen.width, height: screen.width / 1.3)
                
                MainHazardCardDetails(locationName: locationName, hazardCount: hazardCount, showMenu: self.$showMenu)
            }
            .scaleEffect(showMenu ? 0.9 : 1)
            .animation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.5))
            .offset(y: showMenu ? -350 : 0)
            .rotation3DEffect(Angle(degrees: showMenu ? -10 : 0), axis: (x: 10.0, y: 0, z: 0))
            FilterMenuView(showMenu: self.$showMenu, distance: self.$distance, timeFrom: self.$timeFrom, userLocation: userLocation)
                .opacity(showMenu ? 1 : 0)
                .offset(y: showMenu ? 0 : 600)
                .animation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.5))
        }
    }
}


struct MainHazardCardDetails: View {
    let locationName: String
    let hazardCount: Int
    
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .foregroundColor(Color(UIColor.systemBackground))
            
            VStack (alignment: .center) {
                HStack(alignment: .center) {
                    VStack (alignment: .leading){
                        Text(locationName)
                            .font(.largeTitle).bold()
                                                
                        Text("Current Location")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                    
                    Spacer()
                    
                    Text("\(hazardCount)")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                .padding()
                
                Button(action: {
                    self.showMenu.toggle()
                }, label: {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                        .foregroundColor(.white)
                    Text("Filter")
                        .bold() 
                        .foregroundColor(.white)
                })
                .padding(.vertical, 10.0)
                .padding(.horizontal, 20.0)
                .background(Color.yellow)
                .clipShape(Capsule())
            }
        }
        .frame(width: screen.width - 20, height: screen.width * 0.5)
        .padding(.top, screen.width / 2)
        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 20)
    }
}

struct MainHazardCard_Previews: PreviewProvider {
    static var previews: some View {
        HeaderCard(userLocation: CLLocationCoordinate2D(), locationName: "Galway", hazardCount: 3, distance: .constant(20.0), timeFrom: .constant(4))
    }
}
