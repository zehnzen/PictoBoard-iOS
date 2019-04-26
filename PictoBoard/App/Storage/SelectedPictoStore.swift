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

protocol PlannedPictoDelegate {
    func plannedPictosChanged()
}

protocol TodoPictoDelegate {
    func todoPictosChanged()
}

class SelectedPictoStore {
    
    static let shared = SelectedPictoStore()
    
    private let storageProtocol: PictoStorageProtocol
    
    private var plannedPictoDelegate: PlannedPictoDelegate?
    private var todoPictoDelegate: TodoPictoDelegate?
    
    private(set) var plannedPictos: [Picto] = [] {
        didSet {
            storageProtocol.savePlannedPictos(plannedPictos)
            plannedPictoDelegate?.plannedPictosChanged()
        }
    }
    private(set) var todoPictos: [Picto] = [] {
        didSet {
            storageProtocol.saveTodoPictos(todoPictos)
            todoPictoDelegate?.todoPictosChanged()
        }
    }
    
    var allSelectedPictos: [Picto] {
        var pictos = SelectedPictoStore.shared.plannedPictos
        pictos.append(contentsOf: SelectedPictoStore.shared.todoPictos)
        return pictos
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
    
    // MARK: Delgates
    func setPlannedPictoDelegate(delegate: PlannedPictoDelegate) {
        plannedPictoDelegate = delegate
    }
    
    func setTodoPictoDelegate(delegate: TodoPictoDelegate) {
        todoPictoDelegate = delegate
    }
    
    // MARK: checks
    func checkIfSelected(picto: Picto) -> Bool {
        return allSelectedPictos.enumerated().contains{ $0.element == picto }
    }
    
    // MARK: - public Storage mutations
    func tryAddingToPlanned(picto: Picto) -> Bool {
        
        guard plannedPictos.count < SelectedPictoStore.maxPlannedPictos, !allSelectedPictos.contains(picto) else {
            return false
        }
        
        addToPlanned(picto: picto)
        return true
    }
    
    func tryTransferFromPlannedToTodo(picto: Picto) -> Bool {
        
        guard todoPictos.count < SelectedPictoStore.maxTodoPictos else {
            return false
        }
        
        removeFromPlanned(picto: picto)
        addToTodo(picto: picto)
        return true
    }
    
    func removePictoFromTodo(picto: Picto) {
        removeFromTodo(picto: picto)
    }
    
    // MARK: - Private Storage mutations
    private func addToPlanned(picto: Picto) {
        add(picto: picto, to: &plannedPictos, maxSize: SelectedPictoStore.maxPlannedPictos)
    }
    
    private func addToTodo(picto: Picto) {
        add(picto: picto, to: &todoPictos, maxSize: SelectedPictoStore.maxTodoPictos)
    }
    
    private func removeFromPlanned(picto: Picto) {
        remove(picto: picto, from: &plannedPictos)
    }
    
    private func removeFromTodo(picto: Picto) {
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
