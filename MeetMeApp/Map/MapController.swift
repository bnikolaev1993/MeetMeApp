//
//  MapController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 06.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit
import MapKit

class MapController: MKMapView, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var coordinate2D = CLLocationCoordinate2DMake(53.7702356, -2.7671912)
    
    func setupCoreLocation() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways:
            enableLocationServices()
        default:
            break
        }
    }
    
    func enableLocationServices () {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            setUserTrackingMode(.follow, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func disableLocationServices () {
        locationManager.stopUpdatingLocation()
    }
    
    func updateMapRegion(rangeSpan: CLLocationDistance) {
        region = MKCoordinateRegionMakeWithDistance(coordinate2D, rangeSpan, rangeSpan)
    }
    
    func lookUpCurrentLocation(coords: CLLocationCoordinate2D, completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        let geocoder = CLGeocoder()
        let locationFromCoords = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(locationFromCoords, completionHandler: { (placemarks, error) in
            if error == nil {
                guard let firstLocation = placemarks?[0] else { return completionHandler(nil) }
                completionHandler(firstLocation)
            }
            else {
                // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("authorized")
        case .denied, .restricted:
            print("not authorized")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        coordinate2D = location.coordinate
        //let displayLocation = "\(location.timestamp) Coord: \(coordinate2D) Alt: \(location.altitude) meters"
        //print(displayLocation)
        updateMapRegion(rangeSpan: 200)
    }
}
