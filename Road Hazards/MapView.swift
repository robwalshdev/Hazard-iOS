//
//  MapView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 22/02/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    let latitude: Double
    let longitude: Double
    let delta: Double
    let showLocation: Bool
    let annotationLocations: [AnnotationLocation]
    
    @State private var trackingMode = MapUserTrackingMode.none
    
    var body: some View {
        let userLocation: Binding = .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)))
        
        return ZStack {
            if showLocation {
                Map(coordinateRegion: userLocation, interactionModes: .zoom, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: annotationLocations) { annotation in
                        MapMarker(coordinate: annotation.coordinate)
                }
            } else {
                Map(coordinateRegion: userLocation)
            }
        }
    }
}

struct AnnotationLocation: Identifiable {
    let id = UUID()
    var longitude:Double
    var latitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(latitude: 53.0, longitude: -9.0, delta: 0.02, showLocation: false, annotationLocations: [])
    }
}
