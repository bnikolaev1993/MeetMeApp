//
//  DesignableLabel.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 17.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

@IBDesignable class UITextFieldDesignable: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
