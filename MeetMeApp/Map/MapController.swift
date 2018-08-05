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
    var tappedAnnotation: Place?
    private let rangeOfOverlay: Double = 200
    
    func getRange() -> Double {
        return rangeOfOverlay
    }
    
    func getCurrentUserLocation() {
        coordinate2D = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        updateMapRegion(rangeSpan: rangeOfOverlay)
    }
    
    func setupCoreLocation() {
        self.delegate = self
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            getCurrentUserLocation()
            enableLocationServices()
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
        DispatchQueue.global(qos: .userInitiated).async {
            let geocoder = CLGeocoder()
            let locationFromCoords = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(locationFromCoords, completionHandler: { (placemarks, error) in
                if error == nil {
                    guard let firstLocation = placemarks?[0] else { return completionHandler(nil) }
                    DispatchQueue.main.async {
                        completionHandler(firstLocation)
                    }
                }
                else {
                    // An error occurred during geocoding.
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                }
            })
        }
    }
    
    func addMeetingSpaceOverlay(radius: Double) {
        for location in self.annotations {
            if location.coordinate != (locationManager.location?.coordinate)! {
                let circle = MKCircle(center: location.coordinate, radius: radius)
                self.add(circle)
            }
        }
    }
    
    private func lookForAnnotationsAroundMe () {
        for location in self.annotations {
            if location.title != "My Location" {
                let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let dist = locationManager.location?.distance(from: loc)
                //print(location.title!!, " distance is: ", dist!.binade)
                if dist!.binade <= 200 {
                    print(location.title!!, " is in circle! Distance is: ", dist!.binade)
                }
                
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
        lookForAnnotationsAroundMe()
    }
    
    //MARK: MapKit Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? Place else {
            return nil
        }
        if let dequedView = self.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) {
            annotationView = dequedView
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
        annotationView.canShowCallout = false
        annotationView.image = #imageLiteral(resourceName: "pin")
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view:  MKAnnotationView) {
        if view.annotation?.title != "My Location" {
            isAnnotationSelected = true
        guard let place = view.annotation as? Place else {
            return
        }
        tappedAnnotation = place
        print("Tapped on Annotation")
        }
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
    
    static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude ? true : false
    }
}
