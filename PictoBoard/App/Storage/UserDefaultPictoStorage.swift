//
//  UserDefaultPictoStorage.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 20/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation

class UserDefaultPictoStorage {
    
    static let shared = UserDefaultPictoStorage()
    
    private let plannedPictosUserString = "plannedPictos"
    private let todoPictosUserstring = "todoPictos"
    private let pictoStringSeparator = "_"
    private let defaults = UserDefaults.standard
    
    // MARK: Init
    private init() {
        
    }
    
    // MARK: PictoUserConversion
    private func createPicto(from userString: String) -> Picto? {
        let components = userString.split(separator: Character(pictoStringSeparator))
        if components.count != 2 {
            if components.count != 0 {
                print("Error: No splitting occured")
            }
            return nil
        }
        
        let categoryName = String(components[1])
        
        let categoriesUrl = DirectoryHelper.documentDirectoryURLWith(component: PictoCategoriesFileStore.shared.categoriesDirectoryName, isDirectory: true)
        let pictoUrl = categoriesUrl.appendingPathComponent(categoryName).appendingPathComponent(String(components[0]))
        
        if !FileManager.default.isReadableFile(atPath: pictoUrl.path) {
            print("No file found at constructed picto path")
            return nil
        }
        
        return Picto(path: pictoUrl, categoryName: categoryName)
    }
    
    private func createUserPictoString(from picto: Picto) -> String {
        return  picto.path.lastPathComponent + pictoStringSeparator + picto.categoryName
    }
}

//MARK: - PictoStoreProtocol
extension UserDefaultPictoStorage: PictoStorageProtocol {
    
    // MARK: Retrieve Pictos
    func retrievePlannedPictos() -> [Picto] {
        return retrievePictos(userKey: plannedPictosUserString, maxSize: SelectedPictoStore.maxPlannedPictos)
    }
    
    func retrieveTodoPictos() -> [Picto] {
        return retrievePictos(userKey: todoPictosUserstring, maxSize: SelectedPictoStore.maxTodoPictos)
    }
    
    private func retrievePictos(userKey: String, maxSize: Int) -> [Picto] {
        var pictos: [Picto] = []
        
        for i in 0...maxSize {
            let key = "\(userKey)\(i)"
            if let pictoString = defaults.string(forKey: key), let picto = createPicto(from: pictoString) {
                pictos.append(picto)
            }
        }
        
        return pictos
    }
    
    // MARK: Save Pictos
    func savePlannedPictos(_ pictos: [Picto]) {
        save(pictos: pictos, userKey: plannedPictosUserString, maxSize: SelectedPictoStore.maxPlannedPictos)
    }
    
    func saveTodoPictos(_ pictos: [Picto]) {
        save(pictos: pictos, userKey: todoPictosUserstring, maxSize: SelectedPictoStore.maxTodoPictos)
    }
    
    private func save(pictos: [Picto], userKey: String, maxSize: Int) {
        let size = pictos.count
        
        for i in 0 ..< maxSize {
            
            let key = "\(userKey)\(i)"
            var userString = ""
            
            if size > i {
                userString = createUserPictoString(from: pictos[i])
            }
            
            defaults.set(userString, forKey: key)
        }
    }
}
