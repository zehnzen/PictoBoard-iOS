//
//  MainNavigationController.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 15/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

internal final class MainNavigationController: UINavigationController {
    
    var mainViewController: MainViewController {
        guard let mainViewController = self.viewControllers.first as? MainViewController else {
            fatalError("MainNavigationController has an illegal root viewcontroller")
        }
        return mainViewController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}
