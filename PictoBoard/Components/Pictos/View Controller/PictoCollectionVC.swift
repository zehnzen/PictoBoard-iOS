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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard viewModel != nil else {
            fatalError("No PictoViewModel was set when loaded")
        }
        
        
    }
    
    // TODO: The rest
}

// MARK: - CollectionViewDelegate
internal extension PictoCollectionViewController {
    
}

// MARK: - CollectionViewDataSource
internal extension PictoCollectionViewController {
    
}
