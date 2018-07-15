//
//  User.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 28.06.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

public class User: Codable {
    var username: String
    var password: String
    var firstname: String?
    var familyname: String?
    var gender: String?
    var dob: String?
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    public init(username: String, password: String, firstname: String, familyname: String, gender: String, dob: String) {
        self.username = username
        self.password = password
        self.firstname = firstname
        self.familyname = familyname
        self.gender = gender
        self.dob = dob
    }
    
    public func isNil () -> Bool {
        if (username.isEmpty || password.isEmpty)
        {
            return true
        }
        else {
            return false
        }
    }
}
