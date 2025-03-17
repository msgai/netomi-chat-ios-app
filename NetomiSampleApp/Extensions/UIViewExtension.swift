//
//  UIViewExtension.swift
//  NetomiSampleApp
//
//  Created by Akash Gupta on 14/11/24.
//

import UIKit

extension UIView {
    
    ///Sets the corner radius of the view
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    ///Sets the border width of the view
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    ///Sets the border color of the view
    @IBInspectable var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    
}
