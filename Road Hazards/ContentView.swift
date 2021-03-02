//
//  ContentView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 26/01/2021.
//

import SwiftUI
import MapKit
let screen = UIScreen.main.bounds

struct HomeView: View {
    @State var hazards: [Hazard] = []
    
    @State var distance: Double = 25.0
    @State var timeFrom: Int = 4
    
    @ObservedObject var locationManager = LocationManager()

    var userLocation: CLLocationCoordinate2D {
        return(locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D())
    }
    
    var placemark: String { return("\(locationManager.placemark?.administrativeArea?.description ?? "")")
    }

    var body: some View {
        ZStack {
            Color(.white)
            ScrollView(.vertical, showsIndicators: false, content: {
                HeaderCard(userLocation: userLocation, locationName: placemark, hazardCount: hazards.count, distance: self.$distance, timeFrom: self.$timeFrom)
                    .onChange(of: distance, perform: { value in
                        HazardApi(hours: timeFrom, latitude: userLocation.latitude, longitude: userLocation.longitude, radius: distance.rounded(toPlaces: 1)).getHazards { (hazards) in
                            self.hazards = hazards
                        }
                    })
                    .onChange(of: timeFrom, perform: { value in
                        HazardApi(hours: timeFrom, latitude: userLocation.latitude, longitude: userLocation.longitude, radius: distance.rounded(toPlaces: 1)).getHazards { (hazards) in
                            self.hazards = hazards
                        }
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
                    HazardApi(hours: timeFrom, latitude: userLocation.latitude, longitude: userLocation.longitude, radius: distance.rounded(toPlaces: 1)).getHazards { (hazards) in
                        self.hazards = hazards
                    }
                }
            })
        }
         .ignoresSafeArea()
    }
}
 

struct ContentView: View {
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        HomeView()
            .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
