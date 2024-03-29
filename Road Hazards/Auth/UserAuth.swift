//
//  UserAuth.swift
//  Road Hazards
//
//  Created by Robert Walsh on 19/03/2021.
//

import Foundation
import JWTDecode

struct User: Codable {
    var name: String?
    var username: String?
    var password: String?
}

struct AuthToken: Codable {
    var token: String? = ""
}

class UserAuth {
    let url: String = "http://road-hazard.eu-west-1.elasticbeanstalk.com/auth"

    /*
     Authenticate user with username & password
     Method error = false -> successful login no need to throw an error
     Method error = true -> invalid login no need to throw an error
     */
    func authenticateUser(username: String, password: String, loginError: @escaping (Bool) -> ()) {
        let userModel = User(username: username, password: password)
        
        guard let jsonData = try? JSONEncoder().encode(userModel) else {
            print("Error: Trying to convert model to JSON data")
            DispatchQueue.main.async {
                loginError(true)
            }
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
                DispatchQueue.main.async {
                    loginError(true)
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                DispatchQueue.main.async {
                    loginError(true)
                }
                return
            }
            
            UserDefaults.standard.set(authToken.token, forKey: "token")
            
            DispatchQueue.main.async {
                loginError(false)
            }
            return
        }.resume()
        
    }
    
    func registerUser(name: String, username: String, password: String, signUpError: @escaping (Bool) -> ()) {
        let userModel = User(name: name, username: username, password: password)
        
        guard let jsonData = try? JSONEncoder().encode(userModel) else {
            print("Error: Trying to convert model to JSON data")
            DispatchQueue.main.async {
                signUpError(true)
            }
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
                DispatchQueue.main.async {
                    signUpError(true)
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                DispatchQueue.main.async {
                    signUpError(true)
                }
                return
            }
            
            UserDefaults.standard.set(authToken.token, forKey: "token")
            
            DispatchQueue.main.async {
                signUpError(false)
            }
        }.resume()
    }
    
    func getAuthToken() -> Bool {
        // TODO: Check if token is stil valid (Expiry date)
        // If token invalid -> login screen
        let token = getTokenFromDefaults()
        if token != "" {
            let decoded = decodeJWT(token: token)
            return !decoded.expired
        }
        return false
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
    func getUsernameFromToken() -> String {
        let jwt = decodeJWT(token: getTokenFromDefaults())
        
        return jwt.subject!
    }
    
    func getExpireFromToken() -> String {
        let jwt = decodeJWT(token: getTokenFromDefaults())
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: jwt.expiresAt!)
    }
    
    func getDateOfTokenExpiration(jwt: String) -> Date {
        return Date()
    }
    
    func getTokenFromDefaults() -> String {
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func decodeJWT(token: String) -> JWT {
        guard let jwt = try? decode(jwt: token) else {
            return "Error" as! JWT
        }
        
        return jwt
    }
    
}

