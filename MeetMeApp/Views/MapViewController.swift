//
//  MapViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 06.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var trackOutlet: UIImageView!
    @IBOutlet weak var statusLabel: StatusLableDesignable!
    @IBOutlet weak var map: MapController!
    var isTracking: Bool = false
    @IBAction func enableTrackingBtn(_ sender: UIButton) {
        sender.layer.removeAllAnimations()
        if !isTracking {
            isTracking = true
            map.enableLocationServices()
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut, .repeat, .autoreverse], animations: {
                self.trackOutlet.image = #imageLiteral(resourceName: "trackOnLightOnIcon")
                self.trackOutlet.alpha = 0.4
            }, completion: { bool in
                self.trackOutlet.alpha = 1
            })
        }
        else {
            isTracking = false
            self.trackOutlet.layer.removeAllAnimations()
            self.trackOutlet.image = #imageLiteral(resourceName: "trackOffIcon")
            map.disableLocationServices()
        }
    }
    
    @IBAction func mapTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let locationInView = sender.location(in: map)
            let locationInCoords = map.convert(locationInView, toCoordinateFrom: map)
            //print("You tapped on coordinate: \(locationInCoords)")
            map.lookUpCurrentLocation(coords: locationInCoords) { (placemark) in
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.setupCoreLocation()
        // Do any additional setup after loading the view.
    }
}

extension MapViewController: StatusSenderProtocol {
    func sendStatus(status: String) {
        statusLabel.text = status
        statusLabel.alpha = 1
        statusLabel.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        
        statusLabel.clipsToBounds = true
        
        UIView.animate(withDuration: 1, delay: 5, options: .curveEaseOut, animations: {
            self.statusLabel.alpha = 0
            //self.statusLabel.isHidden = true
        }, completion: nil)
    }
    
    func isLogin(status: Bool) {
        print("Place created!")
    }
}
