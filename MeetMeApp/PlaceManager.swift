//
//  PlaceManager.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 01.08.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import MapKit

class PlaceManager: Codable {
    
    var places: [Place]?
    
    func fetchPlaces (city: String) {
        let server = OpenServerNetworkController()
        server.fetchMeetingSpacesByCity(city: city) { (bool, data, error) in
            guard let places = try? JSONDecoder().decode([Place].self, from: data!) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            print(places.debugDescription)
            DispatchQueue.main.async {
                self.places = places
            }
        }
        //return self.places!
    }
    
    func createAnnotationsFromPlaces () -> [MKAnnotation] {
        var annotationsArray: [MKAnnotation] = []
        for item in places! {
            let coords = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            let annotation = MeetingSpaceAnnotation(coords, item.name, item.placemark)
            annotationsArray.append(annotation)
        }
        return annotationsArray
    }
}
