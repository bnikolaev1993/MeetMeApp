//
//  NetworkController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 28.06.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

public protocol NetworkController {
    func registerNewUser(userCred: User?, completionHandler: @escaping(Bool, Error?) -> Void)
    func loginUser(userCred: User?, completionHandler: @escaping(Bool, String, Error?) -> Void)
}

//Errors that may occur during networking processes
public enum NetworkControllerError: Error {
    case invalidURL(String) //The URL is invalid
    case invalidPayload(URL) //The server might return an HTML page instead of a JSON string
    case forwarded(Error) //Other errors
    case invalidLogin(String)
}
