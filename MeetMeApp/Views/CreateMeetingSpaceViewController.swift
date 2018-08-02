//
//  CreateMeetingSpaceViewController.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 22.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//
import MapKit
import UIKit

class CreateMeetingSpaceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var statusLabelOutlet: StatusLableDesignable!
    var state: CLPlacemark?
    let privacyPicker = UIPickerView()
    let privacyPickerValues = ["Public", "Private"]
    var delegate: CoordsSenderProtocol?
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var meetingSpaceNameTF: UITextField!
    @IBOutlet weak var privacyPickerText: UITextField!
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func createMSBtn(_ sender: ButtonDesignable) {
        //Change CreatorID to session variable
        let place = Place(1, meetingSpaceNameTF.text!, (state?.name)!, (state?.locality)!, privacyPickerText.text!, (state?.location?.coordinate.latitude)!, (state?.location?.coordinate.longitude)!)
        let addPlace = OpenServerNetworkController()
        addPlace.createNewMeetingPlace(placeCred: place) { (completed, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.statusLabelOutlet.text = error?.localizedDescription
                    self.statusLabelOutlet.isHidden = false
                }
            }
            if completed {
                self.delegate?.coordsRecieved(true, "Meeting Space Created Successfully!", self.state)
                self.dismiss(animated: true)
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
            streetLabel.text = state?.thoroughfare
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
    
    deinit {
        print("Create Meeting Sapce deinitialized")
    }
}
