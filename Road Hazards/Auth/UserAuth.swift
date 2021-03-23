//
//  UserAuth.swift
//  Road Hazards
//
//  Created by Robert Walsh on 19/03/2021.
//

import Foundation

struct User: Codable {
    var name: String?
    var username: String?
    var password: String?
}

struct AuthToken: Codable {
    var token: String? = ""
}

class UserAuth {
    let url: String = "http://road-hazard-alert-system.eu-west-1.elasticbeanstalk.com/auth"

    func authenticateUser(username: String, password: String) {
        let userModel = User(username: username, password: password)
        
        guard let jsonData = try? JSONEncoder().encode(userModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let authToken = try! JSONDecoder().decode(AuthToken.self, from: data!)
            
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            UserDefaults.standard.set(authToken.token, forKey: "token")
            
        }.resume()
    }
    
    func registerUser(name: String, username: String, password: String) {
        let userModel = User(name: name, username: username, password: password)
        
        guard let jsonData = try? JSONEncoder().encode(userModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: URL(string: url + "/register")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let authToken = try! JSONDecoder().decode(AuthToken.self, from: data!)
            
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            UserDefaults.standard.set(authToken.token, forKey: "token")
        }.resume()
    }
    
    func getAuthToken() -> Bool {
        // TODO: Check if token is stil valid (Expiry date)
        // If token invalid -> login screen
        if UserDefaults.standard.string(forKey: "token") != nil {
            return true
        }
        return false
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
}

