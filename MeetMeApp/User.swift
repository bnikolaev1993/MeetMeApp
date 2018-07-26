//
//  User.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 28.06.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import Sodium

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
    
    public func hashPassword() {
        let sodium = Sodium()
        let hashedStr = sodium.pwHash.str(passwd: self.password.bytes,
                                                 opsLimit: sodium.pwHash.OpsLimitInteractive,
                                                 memLimit: sodium.pwHash.MemLimitInteractive)!
        self.password = hashedStr
    }
}
