//
//  ViewController.swift
//  UiKitGuide
//
//  Created by Davi on 16/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var formContentBuilder = FormContentBuilderImpl()
    private lazy var formCompLayout = FormCompositionalLayout()
    private lazy var dataSource = makeDataSource()
    
    private lazy var collectionView = {
        let cv = UICollectionView(frame: .zero,collectionViewLayout: formCompLayout.layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.cellId)
        cv.register(FormButtonCollectionViewCell.self, forCellWithReuseIdentifier: FormButtonCollectionViewCell.cellId)
        cv.register(FormTextCollectionViewCell.self, forCellWithReuseIdentifier: FormTextCollectionViewCell.cellId)
        cv.register(FormDateCollectionViewCell.self, forCellWithReuseIdentifier: FormDateCollectionViewCell.cellId)
        
        return cv
    }()
    
    override func loadView() {
        super.loadView()
        setup()
        updateDataSource()
    }
    
}
private extension ViewController {
    func setup() {
        view.backgroundColor = .white
        
        collectionView.dataSource = dataSource
        
        // Hierarchy
        view.addSubview(collectionView)
        
        // Constraints
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    func makeDataSource() -> UICollectionViewDiffableDataSource<FormSectionComponent, FormComponent> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) {
            collectionView,  IndexPath, item in
            switch item {
                // Text Form Component
            case is TextFormComponent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTextCollectionViewCell.cellId, for: IndexPath) as! FormTextCollectionViewCell
                cell.bind(item)
                return cell
                
                // Date Form Component
            case is DateFormComponent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormDateCollectionViewCell.cellId, for: IndexPath) as! FormDateCollectionViewCell
                cell.bind(item)
                return cell
                
                // Button Form Component:
            case is ButtonFormComponent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonCollectionViewCell.cellId, for: IndexPath) as! FormButtonCollectionViewCell
                cell.bind(item)
                return cell
                
                // Default
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.cellId, for: IndexPath)
                return cell
                
                
            }
        }
    }
    func  updateDataSource(animated: Bool = false){
        DispatchQueue.main.async {
            [weak self] in
            
            guard let self = self else { return }
            
            var snapshot = NSDiffableDataSourceSnapshot<FormSectionComponent, FormComponent>()
            
            let formSections = self.formContentBuilder.content
            snapshot.appendSections(formSections)
            formSections.forEach{snapshot.appendItems($0.items, toSection: $0)}
            
            self.dataSource.apply(snapshot,animatingDifferences: animated)
        }
    }
}
