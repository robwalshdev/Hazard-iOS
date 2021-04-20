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
    @State private var timeFrom: Int = 4
    @State private var filterHazards: Bool = false
    
    @State private var showSmartHazardsView: Bool = false
    
    @Binding var showTabBar: Bool
    
    var body: some View {        
        ZStack {
            Spacer().fullScreenCover(isPresented: $showSmartHazardsView, content: {
                SmartView(showView: $showSmartHazardsView)
            })
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    // App Title - Welcome / Location?
                    
                    Text("Hazards")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    // Hazard Stories
                    // TODO: Only show a few - e.g. top or trending
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(hazards, id:\.hazardId) { hazard in
                                MiniHazardCardView(hazard: hazard)
                                    .padding(.trailing)
                                    .padding(.bottom, 15)
                            }
                            
                            // Placeholder
                            
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .foregroundColor(Color.gray.opacity(0.05))
                                .frame(width: screen.width/2, height: 80, alignment: .center)
                                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
                                .padding(.trailing)
                                .padding(.bottom, 15)

                            
                        }.padding(.leading)
                    }
                    
                    // Map Card With Annotations

                    MapView(latitude: userLocation.latitude, longitude: userLocation.longitude, delta: 0.4, showLocation: true, annotationLocations: getAnnotationPoints(), interactive: true)
                        .cornerRadius(10)
                        .frame(height: screen.width * 0.8)
                        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 10)
                        .padding(.horizontal)
                    
                    // Location + Filter Card
                    
                    HStack {
                        LocationFilterView(hazardCount: hazards.count, userLocation: userLocation, showFilter: $filterHazards, hazards: $hazards)
                        
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
                        
                        Text("\(Int(UserDefaults.standard.double(forKey: "distance"))) km")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .shadow(color: Color.blue.opacity(0.1), radius: 10, x: 0, y: 10)
                        Text("\(UserDefaults.standard.integer(forKey: "time")) hrs")
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
                            HazardCard(hazard: hazard, showTabBar: $showTabBar, hazards: $hazards, isUserHazard: false)
                                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        
                        // Placeholder Card
                        HStack {
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .foregroundColor(Color.gray.opacity(0.05))
                                .frame(width: screen.width / 1.1, height: 80, alignment: .center)
                                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            Spacer()
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
        HazardApi().getHazards(completion: { (hazards) in
            self.hazards = hazards
        })
    }
    
    func getAnnotationPoints() -> [AnnotationLocation] {
        if self.hazards.count == 0 {
            return []
        }
        
        var toReturn: [AnnotationLocation] = []

        for hazard in self.hazards {
            let point: AnnotationLocation = AnnotationLocation(longitude: hazard.hazardLocation!.longitude!, latitude: hazard.hazardLocation!.latitude!)
            toReturn.append(point)
        }
        
        return toReturn
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userLocation: CLLocationCoordinate2D(), placemark: "Galway", showTabBar: .constant(true))
    }
}
