//
//  LoginViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 03.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var delegate: StatusSenderProtocol?
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var responseLabel: StatusLableDesignable!
    @IBOutlet weak var userCredUI: UIView!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBAction func closePopUpBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        let user = User(username: usernameText.text!, password: passwordText.text!)
        let log = OpenServerNetworkController()
        log.loginUser(userCred: user) { (bool, response, error) in
            if bool != true {
                DispatchQueue.main.async {
                    self.responseLabel.isHidden = false
                    self.responseLabel.text = error?.localizedDescription
                }
            } else {
                print(response)
                DispatchQueue.main.async {
                    self.dismiss(animated: false)
                    self.delegate?.isLogin(status: true)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("Login View de-initialized!")
    }

}

