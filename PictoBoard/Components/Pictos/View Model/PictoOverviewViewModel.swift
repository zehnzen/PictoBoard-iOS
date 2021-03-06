//
//  PictoOverviewViewModel.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

internal final class PictoOverviewViewModel {
    
    private(set) var category: PictoCategory
    
    init(category: PictoCategory) {
        self.category = category
    }
    
    var pictos: [Picto] {
        return PictoCategoriesFileStore.shared.pictos(for: category)
    }
}
