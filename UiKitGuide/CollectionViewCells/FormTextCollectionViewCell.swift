//
//  FormTextCollectionViewCell.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit

class FormTextCollectionViewCell: UICollectionViewCell {
    private lazy var txtField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.cornerRadius = 8
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.systemGray5.cgColor
        
        return txtField
    }()
    
    func bind(_ item: FormComponent)  {
        guard let item = item as? TextFormComponent else { return }
        setup(item:item)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
    }
    
}
private extension FormTextCollectionViewCell {
    
    func setup(item: TextFormComponent){
        txtField.placeholder = "\(item.placeholder)"
        txtField.keyboardType = item.keyboardType
        
        // layout
        contentView.addSubview(txtField)
        
        //constraints
        txtField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        txtField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        txtField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        txtField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        txtField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        
    }
    
}

