//
//  DailyTodoCollectionViewController.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 15/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class DailyTodoCollectionViewController: UICollectionViewController {
    
    private let viewModel = DailyTodoOverviewViewModel()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SelectedPictoStore.shared.setTodoPictoDelegate(delegate: self)
        
        collectionView.register(UINib(nibName: TaskPictoCollectionCell.nibName, bundle: nil), forCellWithReuseIdentifier: TaskPictoCollectionCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    // MARK: Data
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: PlannedPictoDelegate
extension DailyTodoCollectionViewController: TodoPictoDelegate {
    func todoPictosChanged() {
        reloadData()
    }
}

// MARK: - CollectionViewDataSource
internal extension DailyTodoCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.todoPictos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskPictoCollectionCell.identifier, for: indexPath) as! TaskPictoCollectionCell
        
        let image = viewModel.pictoImage(for: indexPath)
        cell.setup(image: image)
        
        return cell
    }
}

// MARK: - CollectionViewDelegate
internal extension DailyTodoCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let picto = viewModel.picto(for: indexPath)
        removePictoFromTodo(picto: picto)
    }
    
    private func removePictoFromTodo(picto: Picto) {
        SelectedPictoStore.shared.removePictoFromTodo(picto: picto)
    }
}


// MARK: - CollectionViewDelegateFlowLayout
extension DailyTodoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // TODO: Check correct size with use of insets
        let width = collectionView.bounds.width - 20
        let height = (collectionView.bounds.height / 3.0) - 20
        
        return CGSize(width: width, height: height)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return .zero
    //    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 0
    //    }
}

