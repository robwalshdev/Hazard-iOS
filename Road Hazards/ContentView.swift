//
//  ContentView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 26/01/2021.
//

import SwiftUI
import MapKit

let screen = UIScreen.main.bounds

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()

    var userLocation: CLLocationCoordinate2D {
        return(locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D())
    }
    
    var placemark: String {
        return("\(locationManager.placemark?.administrativeArea?.description ?? "")")
    }
    
    var body: some View {
        if (UserAuth().getAuthToken()) {
            TabNavigationView(userLocation: userLocation, placemark: placemark)
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
