//
//  DailyTodoOverviewViewModel.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 25/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class DailyTodoOverviewViewModel {
    
    var todoPictos: [Picto] {
        return SelectedPictoStore.shared.todoPictos
    }
    
    func pictoImage(for indexPath: IndexPath) -> UIImage? {
        let picto = todoPictos[indexPath.row]
        return PictoCategoriesFileStore.shared.image(for: picto)
    }
    
    func picto(for indexPath: IndexPath) -> Picto {
        return todoPictos[indexPath.row]
    }
}
