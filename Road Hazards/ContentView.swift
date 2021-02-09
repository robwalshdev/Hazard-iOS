//
//  ContentView.swift
//  Road Hazards
//
//  Created by Robert Walsh on 26/01/2021.
//

import SwiftUI
import BottomBar_SwiftUI

let items: [BottomBarItem] = [
    BottomBarItem(icon: "car.2.fill", title: "Hazards", color: .purple),
    BottomBarItem(icon: "star.fill", title: "Following", color: .yellow),
    BottomBarItem(icon: "plus.circle", title: "Report", color: .red),
    BottomBarItem(icon: "person.fill", title: "Profile", color: .blue)
]

struct HomeView: View {
    @State var hazards: [Hazard] = []
        
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                Spacer(minLength: 20)
                
                MainHazardCard()
                    .padding(15)
                Spacer(minLength: 40)
                
                VStack {
                    ForEach(hazards, id:\.hazardId) { hazard in
                        HazardCard(hazard: hazard)
                    }.padding(20)
                }.onAppear {
                    HazardApi().getHazards { (hazards) in
                        self.hazards = hazards
                    }
                }
            })
        }
    }
}
 

struct ContentView: View {
    @State private var selectedIndex: Int = 0
    
    var selectedItem: BottomBarItem {
        items[selectedIndex]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HomeView()
                        .navigationBarTitle(Text(selectedItem.title))
                    BottomBar(selectedIndex: $selectedIndex, items: items)
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
