//
//  LockSettingsViewController.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class LockSettingsViewController: UIViewController {
    
    private let holdDuration = 2.0 //seconds
    private var timer: Timer?
    
    @IBOutlet weak var settingsContainer: UIView!
    @IBOutlet weak var lockButton: UIButton!
    
    // MARK: - State Handling
    private func toggleState() {
        let isHidden = settingsContainer.isHidden
        
        settingsContainer.isHidden = !isHidden
        let lockImage = !isHidden ? #imageLiteral(resourceName: "lock_50.png") : #imageLiteral(resourceName: "unlock_50.png")
        lockButton.setImage(lockImage, for: .normal)
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
