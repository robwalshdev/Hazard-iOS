//
//  TabNavigationView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 19/03/2021.
//

import SwiftUI
import MapKit

struct TabNavigationView: View {
    
    @State private var selectedIndex: Int = 0
    @State var showModal = false
    
    let tabBarImageNames = ["car.2", "paperplane.fill", "heart"]
    
    @ObservedObject var locationManager = LocationManager()

    var userLocation: CLLocationCoordinate2D {
        return(locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D())
    }
    
    var placemark: String { return("\(locationManager.placemark?.administrativeArea?.description ?? "")")
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Spacer().fullScreenCover(isPresented: $showModal, content: {
                    ReportView(userLocation: userLocation, showView: $showModal)
                })
                
                switch selectedIndex {
                case 0:
                    HomeView(userLocation: userLocation, placemark: placemark)
                default:
                    NavigationView {
                        ProfileView()
                    }
                }
            }
            
            Rectangle()
                .frame(width: screen.width, height: 20, alignment: .center)
                .background(Color.blue.opacity(0.3))
                .blur(radius: 150)
                .ignoresSafeArea(.all)
            
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
            .padding(.horizontal, 20)
            .shadow(color: Color.gray, radius: 100, x: 5, y: 10)
        }
        .statusBar(hidden: true)
    }
}

struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
