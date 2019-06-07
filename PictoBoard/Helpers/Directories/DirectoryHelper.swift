//
//  DirectoryManager.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation

internal final class DirectoryHelper {
    
    static var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func directoryContents(at url: URL) -> [URL] {
        
        let contents: [URL]
        do {
            contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants])
        } catch {
            print(error.localizedDescription)
            contents = []
        }
        
        return contents
    }
    
    static func documentDirectoryURLWith(component: String, isDirectory: Bool) -> URL {
        return DirectoryHelper.documentsUrl.appendingPathComponent(component, isDirectory: isDirectory)
    }
}
