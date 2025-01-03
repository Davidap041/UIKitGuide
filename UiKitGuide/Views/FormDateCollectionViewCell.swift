//
//  FormDateCollectionViewCell.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit
import Combine

class FormDateCollectionViewCell: UICollectionViewCell {
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    private lazy var errorLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor  = UIColor.systemRed
        lbl.text = ""
        
        return lbl
    }()
    
    private lazy  var contentStackVw: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 8
        
        return sv
    }()
    
    private(set) var subject = PassthroughSubject<(Date, IndexPath), Never>()
    
    private var item: DateFormComponent?
    private var indexPath: IndexPath?
    
    func bind(_ item: FormComponent, at indexPath: IndexPath) {
        guard let item = item as? DateFormComponent else {return}
        self.item = item
        self.indexPath = indexPath
        setup(item: item)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
        item = nil
        indexPath = nil
    }
}

private extension FormDateCollectionViewCell {
    
    func setup(item: DateFormComponent) {
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        
        contentView.addSubview(contentStackVw)
        
        contentStackVw.addArrangedSubview(datePicker)
        contentStackVw.addArrangedSubview(errorLbl)
        
        // constraints
        contentStackVw.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentStackVw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8).isActive = true
        contentStackVw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        contentStackVw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
    }
    
    @objc func datePickerChanged(picker: UIDatePicker){
        
        guard let indexPath = indexPath,
              let item = item else { return }
        
        do {
            let selectedDate = datePicker.date
            for  validator in item.validations {
                try validator.validate(selectedDate)
            }
            
            self.errorLbl.text = ""
            self.subject.send((selectedDate, indexPath))
        } catch {
            if let validationError = error as? ValidationError {
                switch validationError {
                case .custom(let message):
                    self.errorLbl.text = message
                }
            }
            print(error)
        }
    }
}
