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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.setupCoreLocation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
