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
    @AppStorage("currentPage") var currentPage = 1

    var userLocation: CLLocationCoordinate2D {
        return(locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D())
    }
    
    var placemark: String {
        return("\(locationManager.placemark?.administrativeArea?.description ?? "")")
    }
    
    var body: some View {
        if currentPage > totalPages {
            if (UserAuth().getAuthToken()) {
                TabNavigationView(userLocation: userLocation, placemark: placemark)
            } else {
                LoginView()
            }
        } else {
            OnboardingView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
