//
//  SelectedPictoStore.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 20/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation

protocol PictoStorageProtocol {
    func retrievePlannedPictos() -> [Picto]
    func retrieveTodoPictos() -> [Picto]
    func savePlannedPictos(_ pictos: [Picto])
    func saveTodoPictos(_ pictos: [Picto])
}

class SelectedPictoStore {
    
    static let shared = SelectedPictoStore()
    
    private let storageProtocol: PictoStorageProtocol
    
    private(set) var plannedPictos: [Picto] = [] {
        didSet {
            storageProtocol.savePlannedPictos(plannedPictos)
            // TODO: Notify relevant classes
        }
    }
    private(set) var todoPictos: [Picto] = [] {
        didSet {
            storageProtocol.saveTodoPictos(todoPictos)
            // TODO: Notify relevant classes
        }
    }
    
    // MARK: Constants
    static let maxPlannedPictos = 6
    static let maxTodoPictos = 3
    
    // MARK: Init
    private init() {
        storageProtocol = UserDefaultPictoStorage.shared
        plannedPictos = storageProtocol.retrievePlannedPictos()
        todoPictos = storageProtocol.retrieveTodoPictos()
    }
    
    // MARK: - Public Storage mutations
    func addPictoToPlanned(picto: Picto) {
        add(picto: picto, to: &plannedPictos, maxSize: SelectedPictoStore.maxPlannedPictos)
    }
    
    func addPictoToTodo(picto: Picto) {
        add(picto: picto, to: &todoPictos, maxSize: SelectedPictoStore.maxTodoPictos)
    }
    
    func removePictoFromPlanned(picto: Picto) {
        remove(picto: picto, from: &plannedPictos)
    }
    
    func removePictoFromTodo(picto: Picto) {
        remove(picto: picto, from: &todoPictos)
    }
    
    // MARK: private inout array functions
    private func add(picto: Picto, to array: inout [Picto], maxSize: Int) {
        guard array.count < maxSize else {
            return
        }
        
        array.append(picto)
    }
    
    private func remove(picto: Picto, from array: inout [Picto]) {
        guard let index = array.firstIndex(of: picto) else {
            return
        }
        
        array.remove(at: index)
    }
}
