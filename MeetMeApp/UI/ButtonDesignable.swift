//
//  ButtonDesignable.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 17.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

@IBDesignable class ButtonDesignable: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
