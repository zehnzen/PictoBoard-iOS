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
        self.name = path.deletingPathExtension().lastPathComponent
        self.categoryName = categoryName
    }
}

// MARK: - Equatable
extension Picto: Equatable {
    static func == (lhs: Picto, rhs: Picto) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.categoryName == rhs.categoryName
    }
}
