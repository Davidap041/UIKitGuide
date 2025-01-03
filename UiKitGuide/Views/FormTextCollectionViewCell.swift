//
//  FormTextCollectionViewCell.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit
import Combine

class FormTextCollectionViewCell: UICollectionViewCell {
    
    private var item: TextFormComponent?
    private var indexPath: IndexPath?
    
    private(set) var subject = PassthroughSubject<(String, IndexPath), Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var txtField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.cornerRadius = 8
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.systemGray5.cgColor
        
        return txtField
    }()
    
    private lazy var errorLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .systemRed
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textAlignment = .center
        lbl.text = ""
        
        return lbl
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    func bind(_ item: FormComponent, at indexPath: IndexPath)  {
        guard let item = item as? TextFormComponent else { return }
        self.indexPath = indexPath
        self.item = item
        setup(item:item)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
        self.item = nil
        self.indexPath = nil
        subscriptions = []
    }
    
}
private extension FormTextCollectionViewCell {
    
    func setup(item: TextFormComponent){
        
        // notification
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: txtField)
            .compactMap { ($0.object as? UITextField)?.text }
            .map{String($0)}
            .sink { [weak self] val in
                guard let self = self,
                      let indexPath = self.indexPath else { return }
                
                do {
                    for validator in item.validations {
                        try validator.validate(val)
                    }
                    self.txtField.valid()
                    self.errorLbl.text = ""
                    self.subject.send((val,indexPath))
                } catch {
                    self.txtField.invalid()
                    if let validationErorr = error as? ValidationError {
                        switch validationErorr {
                        case .custom(let message):
                            self.errorLbl.text = message
                        }
                    }
                    print(error)
                }
            }
            .store(in: &subscriptions)
        
        // setup
        txtField.delegate = self
        txtField.placeholder = "\(item.placeholder)"
        txtField.keyboardType = item.keyboardType
        txtField.layer.borderColor = UIColor.systemGray5.cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 8
        
        // layout
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(txtField)
        contentStackView.addArrangedSubview(errorLbl)
        
        //constraints
        txtField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        errorLbl.heightAnchor.constraint(equalToConstant: 22).isActive = true
        contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
           
    }
}

extension FormTextCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
