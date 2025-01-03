//
//  UiTextField+Validation.swift
//  UiKitGuide
//
//  Created by Davi Paiva on 27/12/24.
//

import UIKit

extension UITextField {
    // Highlight to green if textField it's valid
    func valid(){
        self.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    // Highlight to red if textField it's invalid
    func invalid(){
        self.layer.borderColor = UIColor.systemRed.cgColor
    }
}
