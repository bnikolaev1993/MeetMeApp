//
//  MeetingSpaceAnnotation.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 30.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import MapKit

class MeetingSpaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var identifier = "meetingSpacePin"
    
    init (_ coords: CLLocationCoordinate2D, _ title: String?, _ subtitle: String?) {
        self.coordinate = coords
        self.title = title
        self.subtitle = subtitle
    }
}
