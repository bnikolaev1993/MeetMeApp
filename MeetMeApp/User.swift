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
    var user_id: Int?
    var username: String
    var password: String
    var firstname: String?
    var familyname: String?
    var gender: String?
    var dob: String?
    var placesJoined: [Place]?
    
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
    
    public required init(from decoder: Decoder) throws {
        let superContainer = try decoder.container(keyedBy: ProductKeys.self)
        let container = try superContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
        //let places = try superContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .place)
        placesJoined = try superContainer.decode([Place]?.self, forKey: .place)
        user_id = try container.decode(Int.self, forKey: .user_id)
        username = try container.decode(String.self, forKey: .username)
        password = "hidden"
        firstname = try container.decode(String.self, forKey: .firstname)
        familyname = try container.decode(String.self, forKey: .familyname)
        gender = try container.decode(String.self, forKey: .gender)
        dob = try container.decode(String.self, forKey: .dob)
    }
    
    enum CodingKeys: String, CodingKey {
        case user_id = "id"
        case username
        case password
        case firstname = "name"
        case familyname = "surname"
        case gender
        case dob
        case placesJoined = "Place"
    }
    
    enum ProductKeys: String, CodingKey {
        case user = "User"
        case place = "Place"
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
    
    func getPlaceByID(_ id: Int) -> Int {
        var index: Int = 0
        for item in placesJoined! {
            if item.place_id! == id {
                return index
            }
            index += 1
        }
        return index
    }
}
