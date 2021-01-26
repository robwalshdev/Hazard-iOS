//
//  MainHazardCard.swift
//  Road Hazards
//
//  Created by Robert Walsh on 26/01/2021.
//

import SwiftUI
import MapKit

struct MainHazardCard: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.27194, longitude: -9.04889),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.red)
                .shadow(radius: 5)
            VStack {
                HStack {
                    Text("Galway City")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        // TODO - Edit Radius Size
                    }) {
                        Text("Edit")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .font(.caption)
                            .cornerRadius(15)
                    }
                }
                .frame(width: 300, height: 40, alignment: .leading)
                Spacer()
                Map(coordinateRegion: $region)
                    .cornerRadius(10)
            }.padding()
        }
        .frame(width: 350, height: 300)
    }
}

struct MainHazardCard_Previews: PreviewProvider {
    static var previews: some View {
        MainHazardCard()
    }
}
