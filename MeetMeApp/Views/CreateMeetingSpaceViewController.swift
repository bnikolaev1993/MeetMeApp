//
//  CreateMeetingSpaceViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 22.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//
import MapKit
import UIKit

class CreateMeetingSpaceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var descriptionOutlet: UITextField!
    @IBOutlet weak var statusLabelOutlet: StatusLableDesignable!
    var state: CLPlacemark?
    let privacyPicker = UIPickerView()
    let privacyPickerValues = ["Public", "Private"]
    var delegate: CoordsSenderProtocol?
    var placeManagerDelegate: PlaceManager?
    var currentUserId: Int?
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var meetingSpaceNameTF: UITextField!
    @IBOutlet weak var privacyPickerText: UITextField!
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func createMSBtn(_ sender: ButtonDesignable) {
        //Change CreatorID to session variable
        var cityName = state?.locality!
        if (state?.locality)! == "Престон"
        {
            cityName = "Preston"
        }
        var place = Place(currentUserId!, meetingSpaceNameTF.text!, (state?.name)!, cityName!, descriptionOutlet.text!, privacyPickerText.text!,  (state?.location?.coordinate)!)
        let addPlace = OpenServerNetworkController()
        addPlace.createNewMeetingPlace(placeCred: place) { (completed, place_id, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.statusLabelOutlet.text = error?.localizedDescription
                    self.statusLabelOutlet.isHidden = false
                }
            }
            if completed {
                let credID: Dictionary<String, Int> = ["user_id": self.currentUserId!, "place_id": place_id!]
                addPlace.joinMeetingSpace(credID: credID, completionHandler: { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            place.place_id = place_id!
                            self.placeManagerDelegate?.addPlaceToArray(place)
                            place = (self.placeManagerDelegate?.getLastAddedPlace())!
                            self.delegate?.coordsRecieved(true, "Meeting Space Created Successfully!", place)
                            self.dismiss(animated: true)
                        }
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        privacyPicker.delegate = self
        privacyPicker.dataSource = self
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePrivacyPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(donePrivacyPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        privacyPickerText.inputAccessoryView = toolbar
        privacyPickerText.inputView = privacyPicker
        privacyPickerText.text = privacyPickerValues[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if state != nil{
            streetLabel.text = state?.name
        }
    }
    
    @objc func donePrivacyPicker(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return privacyPickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return privacyPickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        privacyPickerText.text = privacyPickerValues[row]
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
        print("Create Meeting Space deinitialized")
    }
}
