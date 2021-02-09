//
//  Hazrad].swift
//  Road Hazards
//
//  Created by Robert Walsh on 09/02/2021.
//

import Foundation

struct Hazard: Codable {
    var hazardId:String?
    var hazardName:String?
    var hazardType:String?
    var hazardRating:HazardRating?
    var hazardLocation:HazardLocation?
    var creationTime:String
    
    static var example: Hazard {
        Hazard(hazardId: "1", hazardName: "Heavy Traffic", hazardType: "Traffic", hazardRating: HazardRating(up: 10, down: 2), hazardLocation: HazardLocation(longitude: -9.046897, latitude: 53.274247), creationTime: "2021-02-09T14:55:09.213+00:00")
    }
}

struct HazardRating: Codable {
    var up:Int?
    var down:Int?
}

struct HazardLocation: Codable {
    var longitude:Double?
    var latitude:Double?
}

class HazardApi {
    func getHazards(completion: @escaping ([Hazard]) -> ()) {
            let url = URL(string: "http://localhost:5000/hazard")!

            URLSession.shared.dataTask(with: url) { (data, _, _) in

                let hazards = try! JSONDecoder().decode([Hazard].self, from: data!)
                print(hazards)
                DispatchQueue.main.async {
                    completion(hazards)
                }
            }
            .resume()
        }
}
