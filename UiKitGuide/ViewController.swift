//
//  ViewController.swift
//  UiKitGuide
//
//  Created by Davi on 16/12/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private lazy var formContentBuilder = FormContentBuilderImpl()
    private lazy var formCompLayout = FormCompositionalLayout()
    private lazy var dataSource = makeDataSource()
    
    private var subscriptions = Set<AnyCancellable>()
    
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
    
    func  updateDataSource(animated: Bool = false){
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            var snapshot = NSDiffableDataSourceSnapshot<FormSectionComponent, FormComponent>()
            
            let formSections = self.formContentBuilder.formContent
            snapshot.appendSections(formSections)
            formSections.forEach{snapshot.appendItems($0.items, toSection: $0)}
            self.dataSource.apply(snapshot, animatingDifferences: animated)
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<FormSectionComponent, FormComponent> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) {
            [weak self] collectionView,  IndexPath, item in
            
            guard let self = self else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: IndexPath)
                return cell
            }
            
            switch item {
                
                // MARK: Text Form Component
            case is TextFormComponent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTextCollectionViewCell.cellId,
                                                              for: IndexPath) as! FormTextCollectionViewCell
                cell.subject
                    .sink { [weak self] val, index in
                        self?.formContentBuilder.update(val: val, at: index)
                    }
                    .store(in: &self.subscriptions)
                
                cell.bind(item,at: IndexPath)
                return cell
                
                // MARK: Date Form Component
            case is DateFormComponent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormDateCollectionViewCell.cellId,
                                                              for: IndexPath) as! FormDateCollectionViewCell
                cell.subject
                    .sink { [weak self] val, indexPath in
                        self?.formContentBuilder.update(val: val, at: IndexPath)
                    }
                    .store(in: &self.subscriptions)
                cell.bind(item, at: IndexPath)
                return cell
                
                // MARK:  Button Form Component:
            case is ButtonFormItem:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonCollectionViewCell.cellId,
                                                              for: IndexPath) as! FormButtonCollectionViewCell
                cell.subject
                    .sink { [weak self] formId in
                        switch formId {
                        case .submit:
                            self?.formContentBuilder.validate()
                            break
                        default:
                            break
                        }
                    }
                    .store(in: &self.subscriptions)
                cell.bind(item)
                return cell
                
                // MARK:  Default
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: IndexPath)
                return cell
                
                
            }
        }
    }
}
private extension ViewController {
    func setup() {
        
        newUserSubscription()
        
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
    
    func newUserSubscription() {
        formContentBuilder
            .user
            .sink { val in
                print(val)
            }
            .store(in: &subscriptions)
    }
    
}
