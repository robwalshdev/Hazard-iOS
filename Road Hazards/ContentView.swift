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
    BottomBarItem(icon: "star.fill", title: "Following", color: .pink),
    BottomBarItem(icon: "plus.circle", title: "Report", color: .red),
    BottomBarItem(icon: "person.fill", title: "Profile", color: .blue)
]

struct BasicView: View {
    let item: BottomBarItem

    var detailText: String {
        "\(item.title) Detail"
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    Spacer(minLength: 20)
                    MainHazardCard()
                        .padding(15)
                    Spacer(minLength: 40)
                    ForEach(1..<10) { num in
                        HazardCard(hazard: Hazard(hazardType: "Traffic", name: "Heavy Traffic \(num.description)", distance: "5km"))
                            .padding(15)
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
                    BasicView(item: selectedItem)
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
