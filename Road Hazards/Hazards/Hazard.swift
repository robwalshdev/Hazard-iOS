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
        Hazard(hazardId: "1", hazardName: "Heavy Traffic", hazardType: "Traffic", description: "Hazard description", hazardRating: HazardRating(up: [], down: []), hazardLocation: HazardLocation(longitude: -9.046897, latitude: 53.274247), source: "AA", creationTime: "2021-04-08T14:55:09.213+00:00", endDate: "2021-05-08T14:55:09.213+00:00", distance: 10)
    }
}

struct HazardRating: Codable {
    var up:[String]?
    var down:[String]?
}

struct HazardLocation: Codable {
    var longitude:Double?
    var latitude:Double?
}


class HazardApi {
    let url: String = "http://road-hazard.eu-west-1.elasticbeanstalk.com/hazard"
    let token: String = UserDefaults.standard.string(forKey: "token")!
    
    func getHazards(completion: @escaping ([Hazard]) -> ()) {
        let hours = UserDefaults.standard.integer(forKey: "time")
        let latitude = UserDefaults.standard.double(forKey: "lat")
        let longitude = UserDefaults.standard.double(forKey: "lon")
        let radius = UserDefaults.standard.double(forKey: "distance")
        
        let url = URL(string: "\(self.url)/\(hours)?latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)")!

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, _, _) in

            let hazards = try! JSONDecoder().decode([Hazard].self, from: data!)
            DispatchQueue.main.async {
                print(hazards)
                completion(hazards)
            }
        }
        .resume()
    }
    
    func getHazardsByUser(completion: @escaping ([Hazard]) -> ()) {
        let url = URL(string: "\(self.url)/?user=\(UserAuth().getUsernameFromToken())")!

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
        let hazardDataModel = Hazard(hazardName: hazardName, hazardType: hazardType, hazardLocation: HazardLocation(longitude: lon, latitude: lat), source: UserAuth().getUsernameFromToken())
        
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
        var username = UserAuth().getUsernameFromToken()
        var request = URLRequest(url: URL(string: url + "/\(hazardId)/\(vote)?user=\(username)")!)
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
    
    func setQueryDefaults(time: Int, distance: Double, lat: Double, lon: Double) {
        UserDefaults.standard.set(time, forKey: "time")
        
        UserDefaults.standard.set(distance, forKey: "distance")
        
        UserDefaults.standard.set(lat, forKey: "lat")
        
        UserDefaults.standard.set(lon, forKey: "lon")
    }
}
