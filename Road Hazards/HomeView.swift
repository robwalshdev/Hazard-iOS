//
//  HomeView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 19/03/2021.
//

import SwiftUI
import MapKit

struct HomeView: View {
    
    @State var hazards: [Hazard] = []
    
    @State var distance: Double = 25.0
    @State var timeFrom: Int = 4
    
    let userLocation: CLLocationCoordinate2D
    
    let placemark: String

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                HeaderCard(userLocation: userLocation, locationName: placemark, hazardCount: hazards.count, distance: self.$distance, timeFrom: self.$timeFrom)
                    .onChange(of: distance, perform: { value in
                        getHazards()
                    })
                    .onChange(of: timeFrom, perform: { value in
                        getHazards()
                    })
                
                Spacer(minLength: 25)
                                
                VStack (alignment: .leading) {
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
                    .padding(20)
                    .frame(maxWidth: screen.width)
                    
                    ForEach(hazards, id:\.hazardId) { hazard in
                        HazardCard(hazard: hazard)
                    }.padding(10)
                }
                .onAppear {
                    getHazards()
                }
                
                Text("No more hazards... filter to view more!")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.top)
                    .padding(.bottom, screen.width  / 2)

            })
        }
         .ignoresSafeArea()
    }
    
    func getHazards() {
        HazardApi().getHazards(hours: timeFrom, latitude: userLocation.latitude, longitude: userLocation.longitude, radius: distance.rounded(toPlaces: 1), completion: { (hazards) in
            self.hazards = hazards
        })
    }
}
