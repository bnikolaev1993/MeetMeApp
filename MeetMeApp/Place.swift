//
//  Place.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 22.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

public class Place: Codable {
    var creatorID: Int
    var name: String
    var placemark: String
    var privacy: String
    var latitude: Double
    var longitude: Double
    
    init(_ id: Int, _ name: String, _ placemark: String, _ privacy: String, _ lat: Double, _ long: Double) {
        self.creatorID = id
        self.name = name
        self.placemark = placemark
        self.privacy = privacy
        self.longitude = long
        self.latitude = lat
    }
}
