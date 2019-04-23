//
//  PictoCategory.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation

internal final class PictoCategory {
    var name: String
    var path: URL
    var pictos: [Picto]?
    
    init(path: URL) {
        self.path = path
        self.name = path.lastPathComponent
    }
}
