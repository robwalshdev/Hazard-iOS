//
//  MiniHazardCard.swift
//  Road Hazards
//
//  Created by Robert Walsh on 08/04/2021.
//

import SwiftUI

struct MiniHazardCardView: View {
    let hazard: Hazard
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(hazard.hazardName!)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("\(hazard.distance!) km")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .background(Color("LightBlue"))
                        .cornerRadius(5.0)
                }
                
                Spacer()

                Image(systemName: getHazardImage(hazardType: hazard.hazardType!))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 38, maxHeight: 38)
                    .foregroundColor(.white)
                    .padding()
            }
            .padding()
        }
        .frame(width: screen.width / 2.2, height: 80, alignment: .center)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct MiniHazardCard_Previews: PreviewProvider {
    static var previews: some View {
        MiniHazardCardView(hazard: Hazard.example)
    }
}
