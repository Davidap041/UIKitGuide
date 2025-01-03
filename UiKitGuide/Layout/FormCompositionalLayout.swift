//
//  FormCompositionalLayout.swift
//  UiKitGuide
//
//  Created by Davi on 17/12/24.
//

import UIKit
final class FormCompositionalLayout {
    var layout: UICollectionViewCompositionalLayout {
        
        // Setting up Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(44))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Setting up Group
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(44))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutGroupSize,
            subitem: layoutItem,
            count: 1)
        
        layoutGroup.contentInsets = .init(top:0,leading:16,bottom:9,trailing:16)
        
        // Setting up Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = .init(top: 150, leading: 0, bottom: 0, trailing: 0)
        
        let compLayout = UICollectionViewCompositionalLayout(section: layoutSection)
        
        return compLayout
    }
}
