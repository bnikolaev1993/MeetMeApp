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
    @IBAction func joinBtnOutlet(_ sender: UIButton) {
        let credID: Dictionary<String, Int> = ["user_id": currentUser.user_id!, "place_id": place.place_id!]
        let server = OpenServerNetworkController()
        if doJoin {
            server.joinMeetingSpace(credID: credID) { (successful, error) in
                if !successful {
                    DispatchQueue.main.async {
                        self.statusBarOutlet.isHidden = false
                        self.statusBarOutlet.text = "You can't join this Meeting Space!"
                    }
                } else {
                    DispatchQueue.main.async {
                        sender.setTitle("Leave", for: .normal)
                        sender.backgroundColor = UIColor.red
                        self.currentUser.placesJoined?.append(self.place!)
                        self.doJoin = false
                    }
                }
            }
        } else {
            server.leaveMeetingSpace(credID: credID) { (successful, error) in
                if !successful {
                    DispatchQueue.main.async {
                        self.statusBarOutlet.isHidden = false
                        self.statusBarOutlet.text = "You can't leave this Meeting Space!"
                    }
                } else {
                    DispatchQueue.main.async {
                        sender.setTitle("Join", for: .normal)
                        sender.backgroundColor = UIColor.init(hex: 0x007AFF)
                        let index = self.currentUser.getPlaceByID(self.place.place_id!)
                        self.currentUser.placesJoined?.remove(at: index)
                        self.doJoin = true
                    }
                }
            }
        }
    }
    
    var place: Place!
    var currentUser: User!
    var doJoin: Bool!
    @IBOutlet weak var placeDetailOutlet: UILabel!
    @IBOutlet weak var privacyOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UILabel!
    @IBOutlet weak var spaceNameOutlet: UILabel!
    @IBOutlet weak var creatorOutlet: UILabel!
    @IBOutlet weak var statusBarOutlet: StatusLableDesignable!
    @IBOutlet weak var joinBtnLabel: UIButton!
    
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
        
        for item in currentUser.placesJoined! {
            if item.place_id! == place.place_id! {
                joinBtnLabel.setTitle("Leave", for: .normal)
                joinBtnLabel.backgroundColor = UIColor.red
                doJoin = false
            }
        }
    }
}
