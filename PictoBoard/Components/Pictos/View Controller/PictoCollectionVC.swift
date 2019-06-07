//
//  PictoCollectionVC.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 23/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class PictoCollectionViewController: UICollectionViewController {
    
    private var viewModel: PictoOverviewViewModel?
    
    var category: PictoCategory? {
        didSet {
            if let category = category {
                viewModel = PictoOverviewViewModel(category: category)
            }
        }
    }
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard viewModel != nil else {
            fatalError("No PictoViewModel was set when loaded")
        }
        
        navigationController?.title = category?.name
        
        collectionView.register(UINib(nibName: PictoCollectionCell.nibName, bundle: nil), forCellWithReuseIdentifier: PictoCollectionCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    // MARK: Data
    private func reloadData() {
        guard !viewModel!.pictos.isEmpty else {
            return
        }
        
        collectionView.reloadData()
    }
    
    private func pictoCell(at indexPath: IndexPath) -> PictoCollectionCell? {
        return collectionView.cellForItem(at: indexPath) as? PictoCollectionCell
    }
}

// MARK: - CollectionViewDataSource
internal extension PictoCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.pictos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictoCollectionCell.identifier, for: indexPath) as! PictoCollectionCell
        
        let picto = viewModel!.pictos[indexPath.row]
        cell.setup(picto: picto)
        
        return cell
    }
}

// MARK: - CollectionViewDelegate
internal extension PictoCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let picto = viewModel!.pictos[indexPath.row]
        if let cell = pictoCell(at: indexPath) {
            PictoAndCell(picto, cell).handleSelect()
        }
    }
}

// MARK: - PictoAndCell
fileprivate class PictoAndCell {
    
    private let picto: Picto
    private let cell: PictoCollectionCell
    
    init(_ picto: Picto, _ cell: PictoCollectionCell) {
        self.picto = picto
        self.cell = cell
    }
    
    func handleSelect() {
        if cell.isPlanned {
            removeSelectedPicto()
        } else {
            addSelectedPicto()
        }
    }
    
    private func addSelectedPicto() {
        _ = SelectedPictoStore.shared.tryAddingToPlanned(picto: picto)
        setCellPlanned()
    }
    
    private func removeSelectedPicto() {
        let state = SelectedPictoStore.shared.checkState(picto: picto)
        switch state {
        case .planned:
            SelectedPictoStore.shared.removePictoFromPlanned(picto: picto)
        case .todo:
            SelectedPictoStore.shared.removePictoFromTodo(picto: picto)
        default:
            break
        }
        setCellPlanned()
    }
    
    private func setCellPlanned() {
        let isPlanned = SelectedPictoStore.shared.checkIfSelected(picto: picto)
        cell.setPlanned(isPlanned)
    }
}
