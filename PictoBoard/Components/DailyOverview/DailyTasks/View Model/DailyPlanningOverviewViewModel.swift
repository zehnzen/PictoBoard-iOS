//
//  DailyPlanningOverviewViewModel.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 25/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class DailyPlanningOverviewViewModel {
    
    var plannedPictos: [Picto] {
        return SelectedPictoStore.shared.plannedPictos
    }
    
    func pictoImage(for indexPath: IndexPath) -> UIImage? {
        let picto = plannedPictos[indexPath.row]
        return PictoCategoriesFileStore.shared.image(for: picto)
    }
    
    func picto(for indexPath: IndexPath) -> Picto {
        return plannedPictos[indexPath.row]
    }
}
