//
//  MapViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 06.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var trackOutlet: UIImageView!
    @IBOutlet weak var statusLabel: StatusLableDesignable!
    @IBOutlet weak var map: MapController!
    var placeManager: PlaceManager!
    
    @IBAction func enableTrackingBtn(_ sender: UIButton) {
        map.getCurrentUserLocation()
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut, .repeat, .autoreverse], animations: {
            self.trackOutlet.image = #imageLiteral(resourceName: "trackOnLightOnIcon")
            self.trackOutlet.alpha = 0.4
        }, completion: { bool in
            self.trackOutlet.alpha = 1
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.setupCoreLocation()
        placeManager = PlaceManager()
        let loc = map.locationManager.location?.coordinate
        map.lookUpCurrentLocation(coords: loc!) { (placemark) in
            DispatchQueue.main.async {
                self.placeManager.fetchPlaces(city: (placemark?.locality!)!)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.map.addAnnotations(self.placeManager.createAnnotationsFromPlaces())
            self.map.addMeetingSpaceOverlay(radius: self.map.getRange())
        }
        print(1)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.addMS (_:)))
        self.map.addGestureRecognizer(gesture)
    }
    
    @objc func addMS(_ sender:UITapGestureRecognizer){
        print("IS EMPTY: ", self.placeManager.places?.debugDescription as Any)
        if sender.state == .ended {
            let locationInView = sender.location(in: map)
            let locationInCoords = map.convert(locationInView, toCoordinateFrom: map)
            //print("You tapped on coordinate: \(locationInCoords)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if !self.map.isAnnotationSelected {
                    self.map.lookUpCurrentLocation(coords: locationInCoords) { (placemark) in
                        if placemark != nil {
                            print("Placemark name: ", placemark?.name ?? "nil")
                            print("Thoroughfare name: ", placemark?.thoroughfare ?? "nil")
                            print("Sub-Thoroughfare name: ", placemark?.subThoroughfare ?? "nil")
                            print("Country name: ", placemark?.country ?? "nil")
                            let sb = UIStoryboard(name: "MeetMeApp", bundle: nil)
                            let createMSPopUp = sb.instantiateViewController(withIdentifier: "createMSPopUpVC") as? CreateMeetingSpaceViewController
                            createMSPopUp?.state = placemark!
                            createMSPopUp?.delegate = self
                            createMSPopUp?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            createMSPopUp?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                            self.present(createMSPopUp!, animated: true)
                        }
                    }
                }
                self.map.isAnnotationSelected = false
            }
        }
    }
}

extension MapViewController: CoordsSenderProtocol {
    func coordsRecieved(_ status: Bool, _ statusString: String, _ coords: CLPlacemark?) {
        let annotation = MeetingSpaceAnnotation((coords?.location?.coordinate)!, coords?.thoroughfare ?? "nil", coords?.name ?? "nil")
        map.addAnnotation(annotation)
        map.addMeetingSpaceOverlay(radius: map.getRange())
        statusLabel.text = statusString
        statusLabel.alpha = 1
        statusLabel.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        
        statusLabel.clipsToBounds = true
        
        UIView.animate(withDuration: 1, delay: 5, options: .curveEaseOut, animations: {
            self.statusLabel.alpha = 0
            //self.statusLabel.isHidden = true
        }, completion: nil)
    }
}
