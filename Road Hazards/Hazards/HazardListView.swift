//
//  HazardListView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 12/02/2021.
//

import SwiftUI

struct HazardListView: View {
    @State var hazards: [Hazard]
    
    @State var show = false
    
    var body: some View {
        ForEach(hazards.indices, id:\.self) { index in
            GeometryReader { geometry in
                HazardCardView(hazard: hazards[index], show: self.$hazards[index].show)
                    .offset(y: self.show ? -geometry.frame(in: .global).minY : 0)
            }.frame(height: show ? screen.height : 120)
            .frame(maxWidth: show ? .infinity : screen.width - 40)
        }
            

    }
}

struct HazardListView_Previews: PreviewProvider {
    static var previews: some View {
        HazardListView(hazards: [Hazard.example, Hazard.example])
    }
}
