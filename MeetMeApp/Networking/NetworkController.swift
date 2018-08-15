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
    func loginUser(userCred: User?, completionHandler: @escaping(Bool, Data?, Error?) -> Void)
    
    func createNewMeetingPlace(placeCred: Place, completionHandler: @escaping(Bool, Int?, Error?) -> Void)
    func fetchMeetingSpacesByCity(city: String, completionHandler: @escaping(Bool, Data?, Error?) -> Void)
    func joinMeetingSpace(credID: Dictionary<String, Int>, completionHandler: @escaping(Bool, Error?) -> Void)
    func leaveMeetingSpace(credID: Dictionary<String, Int>, completionHandler: @escaping(Bool, Error?) -> Void)
    func deleteMeetingSpace(credID: Dictionary<String, Int>, completionHandler: @escaping(Bool, Error?) -> Void)
    func getPlaceById(placeId: Int, completionHandler: @escaping(Bool, Error?) -> Void)
}

//Errors that may occur during networking processes
public enum NetworkControllerError: Error {
    case invalidURL(String) //The URL is invalid
    case invalidPayload(URL) //The server might return an HTML page instead of a JSON string
    case forwarded(Error) //Other errors
    case invalidLogin(String)
}
