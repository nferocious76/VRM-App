//
//  VRMAPI.swift
//  VRM App
//
//  Created by Neil Francis Hipona on 1/15/18.
//  Copyright © 2018 Neil Francis Hipona. All rights reserved.
//

import Foundation

class VRMAPI {
    
    static let shared = VRMAPI()
    
    private let baseURL: String = "https://vrmapi.victronenergy.com"

    func loginWithUsername(username: String, password: String, completion: @escaping ([String: AnyObject]?, Error?) -> Void) {
        
        let reqURLStr = baseURL + "/v2/auth/login"
        guard let url = URL(string: reqURLStr) else {
            let error = VRMAPI.createError(userInfo: ["message": "invalid url"])
            completion(nil, error)
            return
        }
        
        do {
            let jsonInputData = try JSONSerialization.data(withJSONObject: ["username": username, "password": password], options: JSONSerialization.WritingOptions.prettyPrinted)
            guard let jsonString = NSString(data: jsonInputData, encoding: String.Encoding.utf8.rawValue) else {
                
                let error = VRMAPI.createError(userInfo: ["message": "wrong inputs"])
                completion(nil, error)
                return
            }
            
            let bodydata = NSString(format: "%@", jsonString)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = bodydata.data(using: 4)

            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        print("jsonData: ", jsonData)
                        
                        if let json = jsonData as? [String: AnyObject] {
                            completion(json, nil)
                        }else{
                            let error = VRMAPI.createError(userInfo: ["message": "failed convert"])
                            completion(nil, error)
                        }
                    }catch{
                        print("jsonData error")
                        let error = VRMAPI.createError(userInfo: ["message": "failed convert"])
                        completion(nil, error)
                    }
                }else{
                    completion(nil, error)
                }
            }
            dataTask.resume()
        }catch{
            print("JSON conversion error")
            let error = VRMAPI.createError(userInfo: ["message": "failed convert"])
            completion(nil, error)
        }
    }
    
    func loginAsDemoUser(completion: @escaping ([String: AnyObject]?, Error?) -> Void) {
        
        let reqURLStr = baseURL + "/v2/auth/loginAsDemo"
        guard let url = URL(string: reqURLStr) else {
            let error = VRMAPI.createError(userInfo: ["message": "invalid url"])
            completion(nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("jsonData: ", jsonData)
                    
                    if let json = jsonData as? [String: AnyObject] {
                        completion(json, nil)
                    }else{
                        let error = VRMAPI.createError(userInfo: ["message": "failed convert"])
                        completion(nil, error)
                    }
                }catch{
                    print("jsonData error")
                    let error = VRMAPI.createError(userInfo: ["message": "failed convert"])
                    completion(nil, error)
                }
            }else{
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
    
    func logoutUser(completion: @escaping ([String: AnyObject]?, Error?) -> Void) {
        
        let reqURLStr = baseURL + "/v2/auth/logout"
        guard let url = URL(string: reqURLStr) else {
            let error = VRMAPI.createError(userInfo: ["message": "invalid url"])
            completion(nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(UserInfo.shared.token ?? "")", forHTTPHeaderField: "X-Authorization")
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("jsonData: ", jsonData)
                    
                    if let json = jsonData as? [String: AnyObject] {
                        completion(json, nil)
                    }else{
                        let error = VRMAPI.createError(userInfo: ["message": "failed convert"])
                        completion(nil, error)
                    }
                }catch{
                    print("jsonData error")
                    let error = VRMAPI.createError(userInfo: ["message": "failed convert"])
                    completion(nil, error)
                }
            }else{
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
    
    class func createError(userInfo: [String: String]) -> Error {
        
        return NSError(domain: "vrm.api.error", code: 4776, userInfo: userInfo)
    }
}

extension VRMAPI {
    
    func installations(forID id: Int, completion: @escaping (Any?, Error?) -> Void) {
        
        let reqURLStr = baseURL + "/v2/installations/\(id)/diagnostics"
        guard let url = URL(string: reqURLStr) else {
            let error = VRMAPI.createError(userInfo: ["message": "invalid url"])
            completion(nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(UserInfo.shared.token ?? "")", forHTTPHeaderField: "X-Authorization")
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return completion(nil, error) }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                completion(json, nil)
            }catch{
                print("error fail convert)")
                completion(nil, error)
            }
        }
        dataTask.resume()
    }
    
}
