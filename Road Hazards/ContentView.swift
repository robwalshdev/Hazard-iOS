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
    var body: some View {
        if (UserAuth().getAuthToken()) {
            TabNavigationView()
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
