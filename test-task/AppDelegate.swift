//
//  AppDelegate.swift
//  test-task
//
//  Created by admin on 14/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainViewController = MainViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
}

