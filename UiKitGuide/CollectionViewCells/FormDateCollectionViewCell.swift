//
//  DateFormCollectionViewCell.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit

class FormDateCollectionViewCell: UICollectionViewCell {
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    func bind(_ item: FormComponent) {
        guard let item = item as? DateFormComponent else {return}
        setup(item: item)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
    }
}

private extension FormDateCollectionViewCell{
    func setup(item: DateFormComponent) {
        datePicker.datePickerMode = .date
        
        contentView.addSubview(datePicker)
        
        // constraints
        datePicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
    }
    
}
