//
//  CategoriesFileStore.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation

internal final class PictoCategoriesFileStore {
    
    static let shared = PictoCategoriesFileStore()
    
    private(set) var categories: [PictoCategory] = []
    
    private var categoriesDirectoryName = "Categories"
    
    // MARK: Init
    private init() {
        reloadCategories()
    }
    
    // TODO: Force creation of Categories folder if it isn't there already
    
    // MARK: Getters
    func categoryURL(for categoryName: String) -> URL? {
        
        for url in categoriesDirectories() {
            
            guard url.lastPathComponent == categoryName else {
                continue
            }
            
            guard FileManager.default.fileExists(atPath: url.absoluteString) else {
                return nil
            }
            
            return url
        }
        
        return nil
    }
    
    func pictos(for category: PictoCategory) -> [Picto] {
        if category.pictos == nil {
            reloadPictos(for: category)
        }
        
        if let pictos = category.pictos {
            return pictos
        }
        
        return []
    }
    
    
    // MARK: - Private loaders
    private func categoriesDirectories() -> [URL] {
        guard let categoriesURL = DirectoryHelper.documentDirectoryURLWith(component: categoriesDirectoryName, isDirectory: true) else {
            return []
        }
        
        return DirectoryHelper.directoryContents(at: categoriesURL)
    }
    
    private func reloadCategories() {
        var categories: [PictoCategory]
        
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
