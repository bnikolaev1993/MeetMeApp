//
//  MainMenuViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 18.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "regSeg" {
            let vc = segue.destination as! RegistrationViewController
            vc.delegate = self
        }
        else if segue.identifier == "loginSeg" {
            let vc = segue.destination as! LoginViewController
            vc.delegate = self
        }
        else if segue.identifier == "mapSegue" {
            let vc = segue.destination as! MapViewController
            vc.prevVC = self
        }
    }
    
    @IBOutlet weak var statusLabel: StatusLableDesignable!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("Main Menu is de-initialized!")
    }

}

extension MainMenuViewController: StatusSenderProtocol {
    func sendStatus(status: String) {
        statusLabel.isHidden = false
        statusLabel.text = status
    }
    func isLogin(status: Bool)
    {
        if status {
            print("BOOO!!!")
            performSegue(withIdentifier: "mapSegue", sender: nil)
        }
    }
    
}
