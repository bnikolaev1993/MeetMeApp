//
//  MapController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 06.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import MapKit

class MapController: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var coordinate2D: CLLocationCoordinate2D
    var mapView: MKMapView
    
    public init(map: MKMapView)
    {
        self.mapView = map
        coordinate2D = CLLocationCoordinate2DMake(53.7702356, -2.7671912)
        super.init()
        locationManager.delegate = self
    }
    
    func setupCoreLocation() {
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
            mapView.setUserTrackingMode(.follow, animated: true)
        }
    }
    
    func disableLocationServices () {
        locationManager.stopUpdatingLocation()
    }
    
    func updateMapRegion(rangeSpan: CLLocationDistance) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate2D, rangeSpan, rangeSpan)
        mapView.region = region
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
        let displayLocation = "\(location.timestamp) Coord: \(coordinate2D) Alt: \(location.altitude) meters"
        print(displayLocation)
        updateMapRegion(rangeSpan: 200)
    }
}
