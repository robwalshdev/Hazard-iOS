//
//  ReportHazard.swift
//  Road Hazards
//
//  Created by Robert Walsh on 26/01/2021.
//

import SwiftUI

struct ReportHazard: View {
    var body: some View {
        Button(action: {
            // TODO - POST
        }, label: {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .padding(20)
                .background(Color.blue)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .shadow(radius: 5)
        })
    }
}

struct ReportHazard_Previews: PreviewProvider {
    static var previews: some View {
        ReportHazard()
    }
}
