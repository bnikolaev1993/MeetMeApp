//
//  Place.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 22.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import MapKit

public class Place: NSObject, Codable, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    let creatorID: Int
    let name: String
    let placemark: String
    let city: String
    let privacy: String
    let latitude: Double
    let longitude: Double
    
    public var identifier = "meetingSpacePin"
    
    init(_ id: Int, _ name: String, _ placemark: String, _ city: String, _ privacy: String, _ coordinate: CLLocationCoordinate2D) {
        self.creatorID = id
        self.title = name
        self.subtitle = placemark
        self.name = name
        self.placemark = placemark
        self.privacy = privacy
        self.coordinate = coordinate
        self.longitude = coordinate.longitude
        self.latitude = coordinate.latitude
        self.city = city
    }
    
    enum CodingKeys: String, CodingKey {
        case creatorID = "user_id"
        case name
        case placemark
        case city
        case privacy
        case latitude = "lat"
        case longitude = "long"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        creatorID = try container.decode(Int.self, forKey: .creatorID)
        name = try container.decode(String.self, forKey: .name)
        placemark = try container.decode(String.self, forKey: .placemark)
        city = try container.decode(String.self, forKey: .city)
        privacy = try container.decode(String.self, forKey: .privacy)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        title = name
        subtitle = placemark
    }
}
