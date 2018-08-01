//
//  MapController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 06.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit
import MapKit

class MapController: MKMapView, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var coordinate2D: CLLocationCoordinate2D?
    var isAnnotationSelected = false
    
    func setupCoreLocation() {
        self.delegate = self
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways:
            coordinate2D = locationManager.location?.coordinate
            updateMapRegion(rangeSpan: 200)
        default:
            break
        }
    }
    
    func enableLocationServices () {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            setUserTrackingMode(.follow, animated: true)
        }
    }
    
    func disableLocationServices () {
        locationManager.stopUpdatingLocation()
    }
    
    func updateMapRegion(rangeSpan: CLLocationDistance) {
        region = MKCoordinateRegionMakeWithDistance(coordinate2D!, rangeSpan, rangeSpan)
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
    
    func addMeetingSpaceOverlay(radius: Double) {
        for location in self.annotations {
            if location.coordinate != (locationManager.location?.coordinate)! {
                let circle = MKCircle(center: location.coordinate, radius: radius)
                self.add(circle)
            }
        }
    }
    
    //MARK: Location Manager Delegate
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
    
    //MARK: MapKit Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? MeetingSpaceAnnotation else {
            return nil
        }
        if let dequedView = self.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) {
            annotationView = dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        annotationView.canShowCallout = true
        annotationView.image = #imageLiteral(resourceName: "pin")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view:  MKAnnotationView) {
        isAnnotationSelected = true
        print("Tapped on Annotation")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = UIColor(red: 0.0, green: 0.1, blue: 1.0, alpha: 0.1)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension CLLocationCoordinate2D {
    static func != (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude != rhs.latitude && lhs.longitude != rhs.longitude ? true : false
    }
}
