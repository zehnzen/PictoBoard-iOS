//
//  RewindController.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 05/05/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import Foundation

// MARK: - RewindAction
class RewindAction {
    
    let type: RewindType
    let picto: Picto
    let position: Int?
    
    init(type: RewindType, picto: Picto, position: Int? = nil) {
        
        if type != .addPlanned, position == nil {
            fatalError("ActionType wasn't combined with position when required")
        }
        self.type = type
        self.picto = picto
        self.position = position
    }
}

enum RewindType {
    case addPlanned
    case transferPlannedToTodo
    case removePlanned
    case removeTodo
}

// MARK: - RewindController
final class RewindController {
    
    static let shared = RewindController()
    
    private var rewindActions: [RewindAction] = []
    
    // MARK: Init
    private init() {
        
    }
    
    // MARK: - Public functions
    func addAction(_ action: RewindAction) {
        rewindActions.append(action)
    }
    
    func rewindLastAction() {
        if let lastAction = rewindActions.popLast() {
            lastAction.handleRewind()
        }
    }
}

// MARK: - RewindAction Handlers
fileprivate extension RewindAction {
    
    func handleRewind() {
        switch type {
        case .addPlanned:
            rewindAddPlanned()
        case .transferPlannedToTodo:
            rewindTranferFromPlannedToTodo()
        case .removePlanned:
            rewindRemovePlanned()
        case .removeTodo:
            rewindRemoveTodo()
        }
    }
    
    private func rewindAddPlanned() {
        SelectedPictoStore.shared.rewindAddToPlanned(picto: picto)
    }
    private func rewindTranferFromPlannedToTodo() {
        SelectedPictoStore.shared.rewindTransferFromPlannedToTodo(picto: picto, position: position!)
    }
    private func rewindRemovePlanned() {
        SelectedPictoStore.shared.rewindRemoveFromPlanned(picto: picto, position: position!)
    }
    private func rewindRemoveTodo() {
        SelectedPictoStore.shared.rewindRemoveFromTodo(picto: picto, position: position!)
    }
}
