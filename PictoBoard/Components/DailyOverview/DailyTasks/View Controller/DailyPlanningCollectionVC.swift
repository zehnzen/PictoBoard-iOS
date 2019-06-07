//
//  DailyPlanningCollectionViewController.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 15/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class DailyPlanningCollectionViewController: UICollectionViewController {
    
    private let viewModel = DailyPlanningOverviewViewModel()
    
    private var longPressGesture: UILongPressGestureRecognizer!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SelectedPictoStore.shared.setPlannedPictoDelegate(delegate: self)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
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

// MARK: - PlannedPictoDelegate
extension DailyPlanningCollectionViewController: PlannedPictoDelegate {
    func plannedPictosChanged() {
        reloadData()
    }
}

// MARK: - LongPressGestureRecognizer
extension DailyPlanningCollectionViewController {
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            beginInteractiveMovement(gesture)
        case .changed:
            updateInteractiveMovement(gesture)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private func beginInteractiveMovement(_ gesture: UILongPressGestureRecognizer) {
        guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
            return
        }
        collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
    }
    
    private func updateInteractiveMovement(_ gesture: UILongPressGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: view))
    }
}

// MARK: - CollectionViewDataSource
internal extension DailyPlanningCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.plannedPictos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskPictoCollectionCell.identifier, for: indexPath) as! TaskPictoCollectionCell
        
        let image = viewModel.pictoImage(for: indexPath)
        cell.setup(image: image)
        
        return cell
    }
}

// MARK: - CollectionViewDelegate
internal extension DailyPlanningCollectionViewController {
    
    // MARK: Select item
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let picto = viewModel.picto(for: indexPath)
        movePictoToTodo(picto: picto)
    }
    
    private func movePictoToTodo(picto: Picto) {
        _ = SelectedPictoStore.shared.tryTransferFromPlannedToTodo(picto: picto)
    }
    
    // MARK: Move item
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        SelectedPictoStore.shared.reorderPlanned(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}


// MARK: - CollectionViewDelegateFlowLayout
extension DailyPlanningCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
