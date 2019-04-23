//
//  Picto.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation

internal final class Picto {
    
    var path: URL
    var name: String
    var categoryName: String
    
    init(path: URL, categoryName: String) {
        self.path = path
        self.name = path.lastPathComponent
        self.categoryName = categoryName
    }
}

extension Picto: Equatable {
    // MARK: Equatable
    static func == (lhs: Picto, rhs: Picto) -> Bool {
        return
            lhs.path == rhs.path &&
            lhs.name == rhs.name &&
            lhs.categoryName == rhs.categoryName
    }
}
