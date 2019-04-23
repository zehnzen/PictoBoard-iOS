//
//  CategoryOverviewViewModel.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class CategoryOverviewViewModel {
    
    var categories: [PictoCategory] {
        return PictoCategoriesFileStore.shared.categories
    }
    
    func representingImage(for category: PictoCategory) -> UIImage? {
        
        guard let imagePath = category.pictos?.first?.path else {
            return nil
        }
        
        return UIImage.init(contentsOfFile: imagePath.absoluteString)
    }
}
