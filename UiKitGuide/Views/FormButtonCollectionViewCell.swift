//
//  FormButtonCollectionViewCell.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit
import Combine

final class FormButtonCollectionViewCell: UICollectionViewCell {
 
    private lazy var actionBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return btn
    }()
    
    private var item: ButtonFormItem?
    private(set) var subject = PassthroughSubject<FormField,Never>()
    
    func bind(_ item: FormComponent) {
        guard let item = item as? ButtonFormItem else {return}
        self.item = item
        setup(item: item)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
        self.item = nil
    }
}

private extension FormButtonCollectionViewCell {
    
    func setup(item: ButtonFormItem){
        
        // set elements
        actionBtn.addTarget(self, action: #selector(actionBtnTapped), for: .touchUpInside)
        actionBtn.setTitle(item.title, for: .normal)
        
        // set hierarchy
        contentView.addSubview(actionBtn)
        
        // set constraints
        actionBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        actionBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        actionBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        actionBtn.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        actionBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    @objc func actionBtnTapped(){
        guard let  item = item else { return }
        self.subject.send(item.formID)
    }
    
}
