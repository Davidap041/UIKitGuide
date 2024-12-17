//
//  UICollectionViewCell+CleanUp.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit

extension UICollectionViewCell {
    
    func removeViews(){
        contentView.subviews.forEach{
            $0.removeFromSuperview()
        }
    }
}
