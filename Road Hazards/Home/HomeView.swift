//
//  MainView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 08/04/2021.
//

import SwiftUI
import MapKit

struct HomeView: View {
    
    @State var hazards: [Hazard] = []
    
    let userLocation: CLLocationCoordinate2D
    let placemark: String
    
    @State private var distance: Double = 10.0
    @State private var timeFrom: Int = 24
    @State private var filterHazards: Bool = false
    
    @State private var showSmartHazardsView: Bool = false
        
    var body: some View {        
        ZStack {
            Spacer().fullScreenCover(isPresented: $showSmartHazardsView, content: {
                SmartView(showView: $showSmartHazardsView)
            })
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    // App Title - Welcome / Location?
                    
                    Text("Hazards \(placemark)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    // Hazard Stories
                    // TODO: Only show a few - e.g. top or trending
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(hazards, id:\.hazardId) { hazard in
                                MiniHazardCardView(hazard: hazard).padding(.trailing).padding(.bottom, 15)
                            }
                        }.padding(.leading)
                    }
                    
                    // Map Card With Annotations

                    MapView(latitude: userLocation.latitude, longitude: userLocation.longitude, delta: 0.2, showLocation: true, annotationLocations: [])
                        .cornerRadius(10)
                        .frame(height: screen.width * 0.8)
                        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 10)
                        .padding(.horizontal)
                    
                    // Location + Filter Card
                    
                    HStack {
                        LocationFilterView(hazardCount: hazards.count, distance: $distance, timeFrom: $timeFrom, showFilter: $filterHazards)
                            .onChange(of: distance, perform: { value in
                                getHazards()
                            })
                            .onChange(of: timeFrom, perform: { value in
                                getHazards()
                            })
                        
                        Spacer()
                        
                        Button(action: {
                            showSmartHazardsView.toggle()
                        }, label: {
                            Text(filterHazards ? "" : "Smart Hazards")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .lineLimit(2)
                        })
                        .frame(width: filterHazards ? 50 : screen.width / 2.4, height: filterHazards ? 50 : screen.width / 2.4, alignment: .center)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, filterHazards ? 20 : 0)
                    
                    // Hazards Info - Distance & Time Settings
                    
                    HStack(alignment: .bottom) {
                        Text("Hazards")
                            .font(.title)
                            .bold()
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("\(Int(distance)) km")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .shadow(color: Color.blue.opacity(0.1), radius: 10, x: 0, y: 10)
                        Text("\(timeFrom) hrs")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .shadow(color: Color.blue.opacity(0.1), radius: 10, x: 0, y: 10)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // List of Hazard Cards
                    
                    VStack(alignment: .center) {
                        ForEach(hazards, id:\.hazardId) { hazard in
                            HazardCard(hazard: hazard)
                        }
                        
                        Text("No more hazards... filter to view more!")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.top)
                            .padding(.bottom, screen.width  / 2.5)
                    }
                    .padding(.top)
                    
                    
                }
                .padding(.top)
            }
            .onAppear {
                getHazards()
        }
        }
    }
    
    func getHazards() {
        HazardApi().getHazards(hours: timeFrom, latitude: userLocation.latitude, longitude: userLocation.longitude, radius: distance.rounded(toPlaces: 1), completion: { (hazards) in
            self.hazards = hazards
        })
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userLocation: CLLocationCoordinate2D(), placemark: "Galway")
    }
}
