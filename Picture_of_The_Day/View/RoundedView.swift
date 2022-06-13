//
//  RoundedImageView.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//

import Foundation
import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = newValue
        }
        get {
            self.layer.cornerRadius
        }
    }
}

@IBDesignable
class RoundedImageView: UIImageView {
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = newValue
        }
        get {
            self.layer.cornerRadius
        }
    }
}
