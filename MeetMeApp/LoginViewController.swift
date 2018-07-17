//
//  LoginViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 03.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

protocol StatusProtocol: class {
    func sendStatus(typeState: String)
}

class LoginViewController: UIViewController, StatusProtocol {
    func sendStatus(typeState: String) {
        responseLabel.isHidden = false
        responseLabel.text = typeState
    }
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var userCredUI: UIView!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBOutlet weak var registerBtnOutlet: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        responseLabel.isHidden = true
        if segue.identifier == "regSegue" {
            let vc = segue.destination as! RegistrationViewController
            vc.delegate = self
        }
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        let user = User(username: usernameText.text!, password: passwordText.text!)
        let log = OpenServerNetworkController()
        log.loginUser(userCred: user) { (bool, response, error) in
            if bool != true {
                DispatchQueue.main.async {
                    self.sendStatus(typeState: error!.localizedDescription)
                }
            } else {
                print(response)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "goToMap", sender: sender)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        responseLabel.layer.borderWidth = 0.5
        responseLabel.layer.cornerRadius = 10
        responseLabel.layer.shadowColor = UIColor.black.cgColor
        responseLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        responseLabel.layer.shadowOpacity = 0.7
        responseLabel.layer.shadowRadius = 4.0
        responseLabel.clipsToBounds = true
        
        loginBtnOutlet.layer.cornerRadius = 10
        registerBtnOutlet.layer.cornerRadius = 10
        
        usernameText.layer.cornerRadius = 10
        passwordText.layer.cornerRadius = 10
        
        userCredUI.alpha = 0
        
        // corner radius
        userCredUI.layer.cornerRadius = 10
        
        // border
        userCredUI.layer.borderWidth = 0.5
        userCredUI.layer.borderColor = UIColor.black.cgColor
        
        // shadow
        userCredUI.layer.shadowColor = UIColor.black.cgColor
        userCredUI.layer.shadowOffset = CGSize(width: 3, height: 3)
        userCredUI.layer.shadowOpacity = 0.7
        userCredUI.layer.shadowRadius = 4.0
        
        // Do any additional setup after loading the view.
        UIView.animate(withDuration: 1) {
            self.userCredUI.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
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
