//
//  DisignableView.swift
//  MeetMeApp
//
//  Created by Bogdan Nikolaev on 17.07.2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

@IBDesignable class ViewDesignable: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBInspectable var doShadowBox: Bool = false {
        didSet {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 3, height: 3)
            self.layer.shadowOpacity = 0.7
            self.layer.shadowRadius = 4.0
        }
    }

}
