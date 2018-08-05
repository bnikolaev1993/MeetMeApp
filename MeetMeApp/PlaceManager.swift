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
    
    private var places: [Place]?
    
    func fetchPlaces (city: String) {
        var cityInEnglish = city
        if city == "Престон" {
            cityInEnglish = "Preston"
        }
        let server = OpenServerNetworkController()
        server.fetchMeetingSpacesByCity(city: cityInEnglish) { (bool, data, error) in
            guard let places = try? JSONDecoder().decode([Place].self, from: data!) else {
                print("Error: Couldn't decode data into Place")
                return
            }
            DispatchQueue.main.async {
                self.places = places
            }
        }
        //return self.places!
    }
    
    func addPlaceToArray (_ p: Place) {
        places?.append(p)
    }
    
    func displayPlacesArrayContent () -> String {
        return places.debugDescription
    }
    
    func getPlaces () -> [Place] {
        return (places ?? nil)!
    }
    func getLastAddedPlace() -> Place {
        return places!.last!
    }
}
