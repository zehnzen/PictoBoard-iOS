//
//  PictoCategoriesFileStore.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation
import UIKit

internal final class PictoCategoriesFileStore {
    
    static let shared = PictoCategoriesFileStore()
    
    private(set) var categories: [PictoCategory] = []
    
    var categoriesDirectoryName = "Categories"
    
    // MARK: Init
    private init() {
        reloadCategories()
    }
    
    // TODO: Force creation of Categories folder if it isn't there already
    
    // MARK: Getters
    func categoryURL(for categoryName: String) -> URL? {
        
        return categoriesDirectories()
            .first {
                $0.lastPathComponent == categoryName &&
                FileManager.default.fileExists(atPath: $0.path)
        }
    }
    
    func pictos(for category: PictoCategory) -> [Picto] {
        if category.pictos == nil {
            reloadPictos(for: category)
        }
        
        return category.pictos ?? []
    }
    
    func image(for picto: Picto) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: picto.path)
            return UIImage(data: imageData)
        } catch {
            print("Error: Loading image failed")
        }
        return nil
    }
    
    func representingImage(for category: PictoCategory) -> UIImage? {
        
        guard let picto = pictos(for: category).first else {
            print("No first picto found for: \(category.name)")
            return nil
        }
        
        return image(for: picto)
    }
    
    
    // MARK: - Private loaders
    private func categoriesDirectories() -> [URL] {
        let categoriesURL = DirectoryHelper.documentDirectoryURLWith(component: categoriesDirectoryName, isDirectory: true)
        return DirectoryHelper.directoryContents(at: categoriesURL)
    }
    
    private func reloadCategories() {
        var categories: [PictoCategory] = []
        
        for url in categoriesDirectories() {
            if let category = createCategory(for: url) {
                categories.append(category)
            }
        }
        
        self.categories = categories
    }
    
    private func reloadPictos(for category: PictoCategory) {
        var pictos: [Picto] = []
        
        for url in DirectoryHelper.directoryContents(at: category.path) {
            if let picto = createPicto(for: url, in: category) {
                pictos.append(picto)
            }
        }
        
        category.pictos = pictos
    }
    
    // MARK: Private creators
    private func createCategory(for url: URL) -> PictoCategory? {
        guard url.hasDirectoryPath else {
            return nil
        }
        
        return PictoCategory(path: url)
    }
    
    private func createPicto(for url: URL, in category: PictoCategory) -> Picto? {
        guard !url.hasDirectoryPath else {
            return nil
        }
        
        return Picto(path: url, categoryName: category.name)
    }
}
