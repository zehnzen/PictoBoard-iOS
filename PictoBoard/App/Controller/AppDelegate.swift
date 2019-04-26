//
//  AppDelegate.swift
//  PictoBoard
//
//  Created by Zehna van den Berg on 15/04/2019.
//  Copyright © 2019 Zehnzen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    
    // TODO: Move to more separate place / implement a button
    private func cleanAllUserDefaults() {
        UserDefaultPictoStorage.shared.savePlannedPictos([])
        UserDefaultPictoStorage.shared.saveTodoPictos([])
    }
}

