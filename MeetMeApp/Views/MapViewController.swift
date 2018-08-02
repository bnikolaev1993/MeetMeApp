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
        placeManager = PlaceManager()
        let loc = map.locationManager.location?.coordinate
        map.lookUpCurrentLocation(coords: loc!) { (placemark) in
            DispatchQueue.main.async {
                self.placeManager.fetchPlaces(city: (placemark?.locality!)!)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.map.addAnnotations(self.placeManager.getPlaces())
            self.map.addMeetingSpaceOverlay(radius: self.map.getRange())
            print("Annotations: ", self.map.annotations.count)
        }
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.addMS (_:)))
        self.map.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        map.setupCoreLocation()
    }
    
    @objc func addMS(_ sender:UITapGestureRecognizer){
        print("IS EMPTY: ", self.placeManager.displayPlacesArrayContent() as Any)
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
                            createMSPopUp?.placeManagerDelegate = self.placeManager
                            createMSPopUp?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            createMSPopUp?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                            self.present(createMSPopUp!, animated: true)
                        }
                    }
                }
                else {
                    let place = self.map.tappedAnnotation!
                    let sb = UIStoryboard(name: "MeetMeApp", bundle: nil)
                    let showMSPopUp = sb.instantiateViewController(withIdentifier: "showMSPopUpVC") as? ShowMeetingSpaceViewController
                    showMSPopUp?.place = place
                    showMSPopUp?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    showMSPopUp?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(showMSPopUp!, animated: true)
                }
                self.map.isAnnotationSelected = false
            }
        }
    }
}

extension MapViewController: CoordsSenderProtocol {
    func coordsRecieved(_ status: Bool, _ statusString: String, _ place: Place?) {
        map.addAnnotation(place!)
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
