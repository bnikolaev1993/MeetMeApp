//
//  MainMenuViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 18.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: StatusLableDesignable!
    weak var loginPopUp: LoginViewController?
    weak var regPopUp: RegistrationViewController?
    
    @IBAction func loginBtnPressed(_ sender: ButtonDesignable) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        loginPopUp = sb.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
        loginPopUp?.delegate = self
        loginPopUp?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        loginPopUp?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(loginPopUp!, animated: true)
    }
    @IBAction func registrationButton(_ sender: ButtonDesignable) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        regPopUp = sb.instantiateViewController(withIdentifier: "regVC") as? RegistrationViewController
        regPopUp?.delegate = self
        regPopUp?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        regPopUp?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(regPopUp!, animated: true)
    }
    
    
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
    func isLogin(status: Bool, user: User)
    {
        if status {
            //self.dismiss(animated: false)
            let sb = UIStoryboard(name: "MeetMeApp", bundle: nil)
            let popup = sb.instantiateViewController(withIdentifier: "meetMeTabVC") as! UITabBarController
            popup.selectedIndex = 1
            guard let vc = popup.selectedViewController! as? MapViewController else {
                print("ERROR: Can't assigned CurrentUser")
                return
            }
            vc.currentUser = user
            self.present(popup, animated: true)
        }
    }
    
}
