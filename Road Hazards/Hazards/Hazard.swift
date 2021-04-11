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
    var description:String?
    var hazardRating:HazardRating?
    var hazardLocation:HazardLocation?
    var source:String?
    var creationTime:String?
    var endDate:String?
    var distance: Int?
    
    static var example: Hazard {
        Hazard(hazardId: "1", hazardName: "Heavy Traffic", hazardType: "Traffic", description: "Hazard description", hazardRating: HazardRating(up: 10, down: 2), hazardLocation: HazardLocation(longitude: -9.046897, latitude: 53.274247), source: "AA", creationTime: "2021-04-08T14:55:09.213+00:00", endDate: "2021-05-08T14:55:09.213+00:00", distance: 10)
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
    let url: String = "http://192.168.86.51:5000/hazard"
    let token: String = UserDefaults.standard.string(forKey: "token")!
    
    func getHazards(hours: Int, latitude: Double, longitude: Double, radius: Double, completion: @escaping ([Hazard]) -> ()) {
        let url = URL(string: "\(self.url)/\(hours)?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)")!
        print(url)

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, _, _) in

            let hazards = try! JSONDecoder().decode([Hazard].self, from: data!)
            DispatchQueue.main.async {
                completion(hazards)
            }
        }
        .resume()
    }
    
    func postHazard(hazardName: String, hazardType: String, lat: Double, lon: Double) {
        let hazardDataModel = Hazard(hazardName: hazardName, hazardType: hazardType, hazardLocation: HazardLocation(longitude: lon, latitude: lat))
        
        guard let jsonData = try? JSONEncoder().encode(hazardDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
        }.resume()
    }
    
    func voteHazard(hazardId: String, vote: String) {
        var request = URLRequest(url: URL(string: url + "/\(hazardId)/\(vote)")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
        }.resume()
    }
}
