//
//  OpenServerNetworkController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 28.06.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

final class OpenServerNetworkController: NetworkController {
    func createNewMeetingPlace(placeCred: Place, completionHandler: @escaping (Bool, Int?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let endpoint = "http://macbook-pro-bogdan.local:3012/addPlace"
            let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let endpointURL = URL(string: safeURLString!) else {
                completionHandler(false, nil, NetworkControllerError.invalidURL(safeURLString!))
                return
            }
            //Specify this request as being a POST method
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "POST"
            // Make sure that we include headers specifying that our request's HTTP body
            // will be JSON encoded
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
            
            // Now let's encode out Post struct into JSON data...
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(placeCred)
                // ... and set our request's HTTP body
                request.httpBody = jsonData
                print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            } catch {
                DispatchQueue.main.async {
                    completionHandler(false, nil, error)
                    return
                }
            }
            
            // Create and run a URLSession data task with our JSON encoded POST request
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                print("Server Error: " + responseError.debugDescription)
                    guard responseError == nil else {
                        DispatchQueue.main.async {
                            completionHandler(false, nil, responseError)
                        }
                        return
                    }
                
                // APIs usually respond with the data you just sent in your POST request
                if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                    print("response: ", utf8Representation)
                    if utf8Representation.contains("Saving place failed") {
                        DispatchQueue.main.async {
                            completionHandler(false, nil, NetworkControllerError.invalidURL(utf8Representation))
                        }
                        return
                    }
                } else {
                    print("no readable data received in response")
                }
                DispatchQueue.main.async {
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as? [String:Int] else {
                            DispatchQueue.main.async {
                                completionHandler(false, nil, nil)
                            }
                            return
                        }
                        let posts = json["id"]
                        completionHandler(true, posts, nil)
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchMeetingSpacesByCity(city: String, completionHandler: @escaping(Bool, Data?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            print("Fetching places...")
            let endpoint = "http://macbook-pro-bogdan.local:3012/getPlaceByCity/" + city
            let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let endpointURL = URL(string: safeURLString!) else {
                completionHandler(false, nil, NetworkControllerError.invalidURL(safeURLString!))
                return
            }
            //Specify this request as being a POST method
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "GET"
            // Make sure that we include headers specifying that our request's HTTP body
            // will be JSON encoded
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
            
            // Create and run a URLSession data task with our JSON encoded POST request
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                print("Server Error: " + responseError.debugDescription)
                guard responseError == nil else {
                    DispatchQueue.main.async {
                        completionHandler(false, nil, responseError)
                    }
                    return
                }
                
                // APIs usually respond with the data you just sent in your POST request
                if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                    print("response: ", utf8Representation)
                    if utf8Representation.contains("No city") {
                        DispatchQueue.main.async {
                            completionHandler(false, nil, NetworkControllerError.invalidURL(utf8Representation))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completionHandler(true, data, nil)
                    }
                } else {
                    print("no readable data received in response")
                }
            }
            task.resume()
        }
    }
    
    func joinMeetingSpace(credID: Dictionary<String, Int>, completionHandler: @escaping(Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            print("Joining place...")
            let endpoint = "http://macbook-pro-bogdan.local:3012/joinPlace"
            let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let endpointURL = URL(string: safeURLString!) else {
                completionHandler(false, NetworkControllerError.invalidURL(safeURLString!))
                return
            }
            //Specify this request as being a POST method
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "POST"
            // Make sure that we include headers specifying that our request's HTTP body
            // will be JSON encoded
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
            
            // Now let's encode out Post struct into JSON data...
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(credID)
                // ... and set our request's HTTP body
                request.httpBody = jsonData
                print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            } catch {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                    return
                }
            }
            
            // Create and run a URLSession data task with our JSON encoded POST request
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                print("Server Error: " + responseError.debugDescription)
                guard responseError == nil else {
                    DispatchQueue.main.async {
                        completionHandler(false, responseError)
                    }
                    return
                }
                
                // APIs usually respond with the data you just sent in your POST request
                if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                    print("response: ", utf8Representation)
                    if utf8Representation.contains("Saving place failed") {
                        DispatchQueue.main.async {
                            completionHandler(false, NetworkControllerError.invalidURL(utf8Representation))
                        }
                        return
                    }
                } else {
                    print("no readable data received in response")
                }
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }
            task.resume()
        }
    }
    
    func getPlaceById(placeId: Int, completionHandler: @escaping(Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            print("Get Place by ID...")
            let endpoint = "http://macbook-pro-bogdan.local:3012/getPlaceById/" + String(placeId)
            let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let endpointURL = URL(string: safeURLString!) else {
                completionHandler(false, NetworkControllerError.invalidURL(safeURLString!))
                return
            }
            //Specify this request as being a POST method
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "GET"
            // Make sure that we include headers specifying that our request's HTTP body
            // will be JSON encoded
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
            
            // Create and run a URLSession data task with our JSON encoded POST request
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                print("Server Error: " + responseError.debugDescription)
                guard responseError == nil else {
                    DispatchQueue.main.async {
                        completionHandler(false, responseError)
                    }
                    return
                }
                
                // APIs usually respond with the data you just sent in your POST request
                if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                    print("response: ", utf8Representation)
                    if utf8Representation.contains("Getting place failed") {
                        DispatchQueue.main.async {
                            completionHandler(false, NetworkControllerError.invalidURL(utf8Representation))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completionHandler(true, nil)
                    }
                } else {
                    print("no readable data received in response")
                }
            }
            task.resume()
        }
    }
    
    func leaveMeetingSpace(credID: Dictionary<String, Int>, completionHandler: @escaping(Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            print("Leaving place...")
            let endpoint = "http://macbook-pro-bogdan.local:3012/leavePlace"
            let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let endpointURL = URL(string: safeURLString!) else {
                completionHandler(false, NetworkControllerError.invalidURL(safeURLString!))
                return
            }
            //Specify this request as being a POST method
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "POST"
            // Make sure that we include headers specifying that our request's HTTP body
            // will be JSON encoded
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
            
            // Now let's encode out Post struct into JSON data...
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(credID)
                // ... and set our request's HTTP body
                request.httpBody = jsonData
                print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            } catch {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                    return
                }
            }
            
            // Create and run a URLSession data task with our JSON encoded POST request
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                print("Server Error: " + responseError.debugDescription)
                guard responseError == nil else {
                    DispatchQueue.main.async {
                        completionHandler(false, responseError)
                    }
                    return
                }
                
                // APIs usually respond with the data you just sent in your POST request
                if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                    print("response: ", utf8Representation)
                    if utf8Representation.contains("Leaving place failed") {
                        DispatchQueue.main.async {
                            completionHandler(false, NetworkControllerError.invalidURL(utf8Representation))
                        }
                        return
                    }
                } else {
                    print("no readable data received in response")
                }
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }
            task.resume()
        }
    }
    
    func deleteMeetingSpace(credID: Dictionary<String, Int>, completionHandler: @escaping(Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            print("Deleting place...")
            let endpoint = "http://macbook-pro-bogdan.local:3012/deletePlace"
            let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let endpointURL = URL(string: safeURLString!) else {
                completionHandler(false, NetworkControllerError.invalidURL(safeURLString!))
                return
            }
            //Specify this request as being a POST method
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "POST"
            // Make sure that we include headers specifying that our request's HTTP body
            // will be JSON encoded
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            request.allHTTPHeaderFields = headers
            
            // Now let's encode out Post struct into JSON data...
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(credID)
                // ... and set our request's HTTP body
                request.httpBody = jsonData
                print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            } catch {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                    return
                }
            }
            
            // Create and run a URLSession data task with our JSON encoded POST request
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                print("Server Error: " + responseError.debugDescription)
                guard responseError == nil else {
                    DispatchQueue.main.async {
                        completionHandler(false, responseError)
                    }
                    return
                }
                
                // APIs usually respond with the data you just sent in your POST request
                if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                    print("response: ", utf8Representation)
                    if utf8Representation.contains("Deleting place failed") {
                        DispatchQueue.main.async {
                            completionHandler(false, NetworkControllerError.invalidURL(utf8Representation))
                        }
                        return
                    }
                } else {
                    print("no readable data received in response")
                }
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }
            task.resume()
        }
    }
    
    func registerNewUser(userCred: User?, completionHandler: @escaping (Bool, Error?) -> Void) {
        let endpoint = "http://macbook-pro-bogdan.local:3012/addUser"
        let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let endpointURL = URL(string: safeURLString!) else {
            completionHandler(false, NetworkControllerError.invalidURL(safeURLString!))
            return
        }
        //Specify this request as being a POST method
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(userCred)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completionHandler(false, error)
            return
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            print("Server Error: " + responseError.debugDescription)
            guard responseError == nil else {
                completionHandler(false, responseError)
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
                if utf8Representation.contains("Saving user failed") {
                    completionHandler(false, NetworkControllerError.invalidURL(utf8Representation))
                    return
                }
            } else {
                print("no readable data received in response")
            }
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    func loginUser(userCred: User?, completionHandler: @escaping(Bool, Data?, Error?) -> Void) {
        if userCred!.isNil() {
            completionHandler(false, nil, NetworkControllerError.invalidLogin("Empty Fields"))
            return
        }
        
        let endpoint = "http://macbook-pro-bogdan.local:3012/login"
        var res = "";
        let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let endpointURL = URL(string: safeURLString!) else {
            completionHandler(false, nil, NetworkControllerError.invalidURL(safeURLString!))
            return
        }
        //Specify this request as being a POST method
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(userCred)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completionHandler(false, nil, error)
            return
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard response != nil else {
                completionHandler(false, nil, responseError)
                return
            }
            let httpResponse = response as! HTTPURLResponse
            print("Server Error: " + httpResponse.statusCode.description)
            guard responseError == nil else {
                completionHandler(false, nil, responseError)
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
                res = utf8Representation
                if res.contains("Invalid") {
                    completionHandler(false, nil, NetworkControllerError.invalidLogin(res))
                    return
                }
            } else {
                print("no readable data received in response")
            }
            completionHandler(true, responseData!, nil)
        }
        task.resume()
    }
}
