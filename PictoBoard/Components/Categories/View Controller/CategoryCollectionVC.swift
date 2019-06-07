//
//  CategoryCollectionVC.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class CategoryCollectionViewController: UICollectionViewController {
    
    private let viewModel = CategoryOverviewViewModel()
    
    private var selectedCategory: PictoCategory?
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Check why title isn't set
        navigationController?.title = "Categories"
        
        collectionView.register(UINib(nibName: CategoryCollectionCell.nibName, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? PictoCollectionViewController, let selected = selectedCategory {
            destination.category = selected
        }
    }
    
    // MARK: Data
    func reloadData() {
        guard !viewModel.categories.isEmpty else {
            return
        }
        
        collectionView.reloadData()
    }
}

// MARK: - CollectionViewDataSource
internal extension CategoryCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as! CategoryCollectionCell
        
        let category = viewModel.categories[indexPath.row]
        let image = PictoCategoriesFileStore.shared.representingImage(for: category)
        
        cell.setup(category: category, image: image)
        
        return cell
    }
}

// MARK: - CollectionViewDelegate
internal extension CategoryCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = viewModel.categories[indexPath.row]
        performSegue(withIdentifier: "showPictoOverview", sender: nil)
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // TODO: Check correct size with use of insets
        let width = (collectionView.bounds.width / 3.0) - 20
        let height = (collectionView.bounds.height / 2.0) - 20
        
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
