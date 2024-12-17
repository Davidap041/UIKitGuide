//
//  FormButtonCollectionViewCell.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit

final class FormButtonCollectionViewCell: UICollectionViewCell {
 
    private lazy var actionBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return btn
    }()
    
   
    func bind(_ item: FormComponent) {
        guard let item = item as? ButtonFormComponent else {return}
        setup(item: item)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeViews()
    }
}

private extension FormButtonCollectionViewCell {
    func setup(item: ButtonFormComponent){
        actionBtn.setTitle(item.title, for: .normal)
        
        contentView.addSubview(actionBtn)
        
        // set constraints
        actionBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        actionBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        actionBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        actionBtn.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        actionBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
