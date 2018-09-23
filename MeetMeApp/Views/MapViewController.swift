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
    public var currentUser: User!
    public var currentCity: String!
    
    @IBAction func enableTrackingBtn(_ sender: UIButton) {
        map.getCurrentUserLocation()
        UIView.animate(withDuration: 5, delay: 0, options: [.curveEaseOut, .repeat, .autoreverse], animations: {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let loc = self.map.locationManager.location?.coordinate
            self.map.lookUpCurrentLocation(coords: loc!) { (placemark) in
                DispatchQueue.main.async {
                    let tvc = self.tabBarController as! UserTabController
                    tvc.currentCity = (placemark?.locality)!
                    self.currentCity = tvc.currentCity
                }
            }
        }
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.addMS (_:)))
        self.map.addGestureRecognizer(gesture)
        print("View Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tvc = self.tabBarController as! UserTabController
        currentUser = tvc.currentUser
        currentCity = tvc.currentCity
        trackOutlet.image = #imageLiteral(resourceName: "trackOnIcon")
        if !tvc.currentCity.isEmpty {
            updateMap()
        }
        displayCurrentUserInfo()
        print("View Will Appear")
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
                            createMSPopUp?.currentUserId = self.currentUser.user_id!
                            createMSPopUp?.delegate = self
                            createMSPopUp?.placeManagerDelegate = self.placeManager
                            createMSPopUp?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            createMSPopUp?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                            self.present(createMSPopUp!, animated: true)
                        }
                    }
                }
                else {
                    guard let place = self.map.tappedAnnotation else {
                        return
                    }
                    let sb = UIStoryboard(name: "MeetMeApp", bundle: nil)
                    let showMSPopUp = sb.instantiateViewController(withIdentifier: "showMSPopUpVC") as? ShowMeetingSpaceViewController
                    showMSPopUp?.place = place
                    showMSPopUp?.currentUser = self.currentUser!
                    showMSPopUp?.delegate = self
                    showMSPopUp?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    showMSPopUp?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(showMSPopUp!, animated: true)
                }
                self.map.isAnnotationSelected = false
            }
        }
    }
    
    deinit {
        print("Map View Deinitialized!")
    }
}

extension MapViewController: CoordsSenderProtocol {
    func coordsRecieved(_ status: Bool, _ statusString: String, _ place: Place?) {
        currentUser.placesJoined?.append(place!)
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

extension MapViewController: UpdateMapProtocol {
    func updateMap() {
        self.map.removeAnnotations(map.annotations)
        self.map.removeOverlays(map.overlays)
        self.placeManager.fetchPlaces(city: self.currentCity) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.map.addAnnotations(self.placeManager.getPlaces())
                    self.map.addMeetingSpaceOverlay(radius: self.map.getRange())
                    print("Annotations: ", self.map.annotations.count)
                }
            }
        }
    }
    
    func showChat(placeID: Int) {
        let main = self.tabBarController?.viewControllers?[2] as? ChatViewController
        main?.placeID = placeID
        self.tabBarController?.selectedIndex = 2
    }
}

extension MapViewController {
    func displayCurrentUserInfo () {
        print("Current ID: ", currentUser.user_id!)
        print("Current user: ", currentUser.username)
        print("Places: ", currentUser.placesJoined!.count)
    }
}
