//
//  SelectedPictoStore.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 20/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation

// MARK: - PictoStorageProtocol
protocol PictoStorageProtocol {
    func retrievePlannedPictos() -> [Picto]
    func retrieveTodoPictos() -> [Picto]
    func savePlannedPictos(_ pictos: [Picto])
    func saveTodoPictos(_ pictos: [Picto])
}

// MARK: - DelegateProtocols
protocol PlannedPictoDelegate {
    func plannedPictosChanged()
}

protocol TodoPictoDelegate {
    func todoPictosChanged()
}

// MARK: - SelectedPictoStore
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
    
    // MARK: Delegates
    func setPlannedPictoDelegate(delegate: PlannedPictoDelegate) {
        if plannedPictoDelegate != nil {
            print("plannedPictoDelegate changed after having been set, consider allowing multiple observers")
        }
        plannedPictoDelegate = delegate
    }
    
    func setTodoPictoDelegate(delegate: TodoPictoDelegate) {
        if todoPictoDelegate != nil {
            print("todoPictoDelegate changed after having been set, consider allowing multiple observers")
        }
        todoPictoDelegate = delegate
    }
    
    // MARK: checks
    func checkIfSelected(picto: Picto) -> Bool {
        return allSelectedPictos.enumerated().contains{ $0.element == picto }
    }
    
    enum SelectedState {
        case not
        case planned
        case todo
    }
    
    func checkState(picto: Picto) -> SelectedState {
        if plannedPictos.contains(picto) {
            return .planned
        }
        
        if todoPictos.contains(picto) {
            return .todo
        }
        
        return .not
    }
}

// MARK: - Overview mutations
extension SelectedPictoStore {
    
    func tryAddingToPlanned(picto: Picto) -> Bool {
        
        guard plannedPictos.count < SelectedPictoStore.maxPlannedPictos, !allSelectedPictos.contains(picto) else {
            return false
        }
        
        addToPlanned(picto: picto)
        RewindController.shared.addAction(RewindAction(type: .addPlanned, picto: picto))
        return true
    }
    
    func tryTransferFromPlannedToTodo(picto: Picto) -> Bool {
        
        guard todoPictos.count < SelectedPictoStore.maxTodoPictos else {
            return false
        }
        
        let position = plannedPictos.firstIndex(of: picto)
        removeFromPlanned(picto: picto)
        addToTodo(picto: picto)
        RewindController.shared.addAction(RewindAction(type: .transferPlannedToTodo, picto: picto, position: position))
        return true
    }
    
    func removePictoFromPlanned(picto: Picto) {
        let position = plannedPictos.firstIndex(of: picto)
        removeFromPlanned(picto: picto)
        RewindController.shared.addAction(RewindAction(type: .removePlanned, picto: picto, position: position))
    }
    
    func removePictoFromTodo(picto: Picto) {
        let position = todoPictos.firstIndex(of: picto)
        removeFromTodo(picto: picto)
        RewindController.shared.addAction(RewindAction(type: .removeTodo, picto: picto, position: position))
    }
    
    func reorderPlanned(from: Int, to: Int) {
        reorderInPlanned(from: from, to: to)
    }
}

// MARK: - Rewind mutations
extension SelectedPictoStore {
    
    func rewindAddToPlanned(picto: Picto) {
        removeFromPlanned(picto: picto)
    }
    
    func rewindTransferFromPlannedToTodo(picto: Picto, position: Int) {
        removeFromTodo(picto: picto)
        insertToPlanned(picto: picto, at: position)
    }
    
    func rewindRemoveFromPlanned(picto: Picto, position: Int) {
        insertToPlanned(picto: picto, at: position)
    }
    
    func rewindRemoveFromTodo(picto: Picto, position: Int) {
        insertToTodo(picto: picto, at: position)
    }
}

// MARK: - Private Storage mutations
private extension SelectedPictoStore {
    
    // MARK: Simple add/removal
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
    
    // MARK: Insertion
    private func insertToPlanned(picto: Picto, at: Int) {
        insert(picto: picto, to: &plannedPictos, at: at)
    }
    
    private func insertToTodo(picto: Picto, at: Int) {
        insert(picto: picto, to: &todoPictos, at: at)
    }
    
    // MARK: Reordering
    private func reorderInPlanned(from: Int, to: Int) {
        let picto = plannedPictos.remove(at: from)
        plannedPictos.insert(picto, at: to)
    }
    
    // MARK: private inout Picto array functions
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
    
    private func insert(picto: Picto, to array: inout [Picto], at: Int) {
        array.insert(picto, at: at)
    }
}
