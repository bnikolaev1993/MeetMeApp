//
//  RegistrationViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 28.06.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var firstnameText: UITextField!
    @IBOutlet weak var familynameText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var errorMsgLabel: StatusLableDesignable!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var userCredUI: UIView!
    @IBAction func closePopUpBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    var delegate: StatusSenderProtocol?
    
    @IBAction func SubmitBtnPressed(_ sender: Any) {
        //let user = User(username: usernameText.text!, firstname: firstnameText.text!, familyname: familynameText.text!, gender: genderText.text!, dob: dobText.text!)
        let user = User(username: "q", password: "q", firstname: "q", familyname: "String", gender: "c", dob: "17.06.2018")
        let register = OpenServerNetworkController()
        register.registerNewUser(userCred: user) { (bool, error) in
            print("Registered: " + bool.description)
            if bool == true {
                DispatchQueue.main.async {
                    self.delegate?.sendStatus(status: "Registered Successfully!")
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
        self.hideKeyboardWhenTappedAround() 
    }
    
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
    
    //MARK: TextFieldDelegate
    
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    deinit {
        print("Registration View de-initialized!")
    }

}
