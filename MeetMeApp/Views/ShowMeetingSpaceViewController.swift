//
//  ShowMeetingSpaceViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 02.08.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class ShowMeetingSpaceViewController: UIViewController {
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    var place: Place?
    @IBOutlet weak var placeDetailOutlet: UILabel!
    @IBOutlet weak var privacyOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UILabel!
    @IBOutlet weak var spaceNameOutlet: UILabel!
    @IBOutlet weak var creatorOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        privacyOutlet.text = place!.privacy
        descriptionOutlet.text = place!.placeDescription
        spaceNameOutlet.text = place!.name
        placeDetailOutlet.text = place!.placemark
        creatorOutlet.text = String(place!.creatorID)
    }
}
