//
//  SettingsViewController.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 19/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func pressedRewindButton(_ sender: Any) {
        // TODO: implement rewind function
    }
}
