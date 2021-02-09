//
//  HazardDataStore.swift
//  Road Hazards
//
//  Created by Robert Walsh on 09/02/2021.
//

import Foundation

class HazardDataStore: ObservableObject {
    @Published var hazards: [Hazard] = []

    init() {
        getHazards()
        print(hazards)
    }
    
    func getHazards() {
        HazardApi().getHazards { (hazards) in
            self.hazards = hazards
         }
    }
}

