//
//  RegistrationViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 28.06.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var firstnameText: UITextField!
    @IBOutlet weak var familynameText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var dobText: UITextField!
    @IBOutlet weak var errorMsgLabel: UILabelPadding!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var userCredUI: UIView!
    
    var delegate: StatusProtocol?
    
    @IBAction func SubmitBtnPressed(_ sender: Any) {
        //let user = User(username: usernameText.text!, firstname: firstnameText.text!, familyname: familynameText.text!, gender: genderText.text!, dob: dobText.text!)
        let user = User(username: "q", password: "q", firstname: "q", familyname: "String", gender: "c", dob: "17.06.2018")
        let register = OpenServerNetworkController()
        register.registerNewUser(userCred: user) { (bool, error) in
            print("Registered: " + bool.description)
            if bool == true {
                DispatchQueue.main.async {
                    self.delegate?.sendStatus(typeState: "Registered Successfully!")
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("[APP.ERROR:]" + error!.localizedDescription)
                DispatchQueue.main.async {
                    self.errorMsgLabel.isHidden = false
                    self.errorMsgLabel.text = "[APP.ERROR:]" + error!.localizedDescription
                }
            }
        }
    }
    
    @IBOutlet weak var datePickerText: UITextField!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        
        errorMsgLabel.layer.borderWidth = 0.5
        errorMsgLabel.layer.cornerRadius = 10
        errorMsgLabel.layer.shadowColor = UIColor.black.cgColor
        errorMsgLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        errorMsgLabel.layer.shadowOpacity = 0.7
        errorMsgLabel.layer.shadowRadius = 4.0
        errorMsgLabel.clipsToBounds = true
        
        usernameText.layer.cornerRadius = 10
        passwordText.layer.cornerRadius = 10
        firstnameText.layer.cornerRadius = 10
        familynameText.layer.cornerRadius = 10
        genderText.layer.cornerRadius = 10
        dobText.layer.cornerRadius = 10
        
        submitBtnOutlet.layer.cornerRadius = 10
        
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
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        datePickerText.inputAccessoryView = toolbar
        datePickerText.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        datePickerText.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

}
