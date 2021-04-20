//
//  SmartHazard.swift
//  Road Hazards
//
//  Created by Robert Walsh on 18/04/2021.
//

import Foundation

struct SmartHazard: Codable {
    var smartId: String!
    var keyPhrase: String!
    var location: String!
    var url: String!
    
    static var example: SmartHazard {
        SmartHazard(smartId: "123456", keyPhrase: "Dublin Port Tunnel", location: "Dublin", url: "https://twitter.com/i/web/status/1383743066335416328")
    }
}

class SmartHazardApi {
    let url: String = "http://192.168.86.51:5000/smart"
    let token: String = UserDefaults.standard.string(forKey: "token")!
    
    func getSmartHazards(completion: @escaping ([SmartHazard]) -> ()) {
        let url = URL(string: self.url)!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, _, _) in

            let smartHazards = try! JSONDecoder().decode([SmartHazard].self, from: data!)
            DispatchQueue.main.async {
                completion(smartHazards)
            }
        }
        .resume()
    }
}
