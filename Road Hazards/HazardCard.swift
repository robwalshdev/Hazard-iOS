//
//  HazardCard.swift
//  Road Hazards
//
//  Created by Robert Walsh on 26/01/2021.
//

import SwiftUI

struct Hazard {
    let hazardType: String
    let name: String
    let distance: String
    
    static var example: Hazard {
        Hazard(hazardType: "car.2", name: "Heavy traffic on M6 entering Galway", distance: "5km")
    }
}

struct HazardCard: View {
    let hazard: Hazard
            
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color("CardBackground"))
                .shadow(radius: 5)
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("IconBackground"))
                        .frame(width: 64, height: 64)
                    Image(systemName: "car.2")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 48, height: 48)
                        .foregroundColor(.white)
                }
                Spacer(minLength: 20)
                VStack(alignment: .leading) {
                    Text(hazard.name)
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                    Spacer()
                        .frame(height: 10.0)
                    HStack {
                        Text(hazard.distance)
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Spacer()
                        Text("10 mins ago")
                            .foregroundColor(.white)
                            .font(.footnote)
                    }
                    
                }
                .padding(-3.0)
                .frame(width: 250.0)
            }
            .padding()
            Circle()
                .fill(Color("RedVote"))
                .frame(width: 20, height: 20)
                .position(x: 350, y: 0)
                .shadow(radius: 5)
            Circle()
                .fill(Color("GreenVote"))
                .frame(width: 40, height: 40)
                .position(x: 330, y: -10)
                .shadow(radius: 5)
                .animation(.easeInOut(duration: 1))
        }
        .frame(width: 350, height: 120
        )
    }
}

struct HazardCard_Previews: PreviewProvider {
    static var previews: some View {
        HazardCard(hazard: Hazard.example)
    }
}
