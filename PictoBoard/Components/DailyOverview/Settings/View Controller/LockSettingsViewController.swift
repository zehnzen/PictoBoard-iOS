//
//  LockSettingsViewController.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class LockSettingsViewController: UIViewController {
    
    private let holdDuration = 3.0 //seconds
    private var timer: Timer?
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var lockButton: UIButton!
    
    // MARK: - State Handling
    private func toggleState() {
        let visibleState = !settingsContainer.isHidden
        
        settingsContainer.isHidden = !visibleState
        lockButton.backgroundColor = visibleState ? .blue : .red // Replace with correct images
    }
    
    // MARK: Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: holdDuration, repeats: false) { _ in
            self.toggleState()
        }
    }
    
    private func cancelTimer() {
        timer?.invalidate()
    }
    
    // MARK: - LockButton Touches
    @IBAction func touchDownLockButton(_ sender: UIButton) {
        startTimer()
    }
    @IBAction func touchUpInsideLockButton(_ sender: UIButton) {
        cancelTimer()
    }
    @IBAction func touchUpOutsideLockButton(_ sender: UIButton) {
        cancelTimer()
    }
}
