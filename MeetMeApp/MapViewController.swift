//
//  MapViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 06.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MapController!
    @IBAction func enableTrackingBtn(_ sender: Any) {
        map.enableLocationServices()
    }
    @IBAction func disableTrackingBtn(_ sender: Any) {
        map.disableLocationServices()
    }
    @IBAction func mapTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let locationInView = sender.location(in: map)
            let locationInCoords = map.convert(locationInView, toCoordinateFrom: map)
            print("You tapped on coordinate: \(locationInCoords)")
        }
    }
    
    var prevVC: MainMenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc = sb.instantiateViewController(withIdentifier: "loginVC")
        vc.dismiss(animated: false)
        vc = sb.instantiateViewController(withIdentifier: "mainVC")
        vc.dismiss(animated: false)
        map.setupCoreLocation()
        // Do any additional setup after loading the view.
    }
}
