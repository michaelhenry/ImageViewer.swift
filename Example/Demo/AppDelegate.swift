//
//  AppDelegate.swift
//  Demo
//
//  Created by Michael Henry Pantaleon on 2019/11/29.
//  Copyright © 2019 Michael Henry Pantaleon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let galleryVC = GalleryViewController()
        window?.rootViewController = UINavigationController(rootViewController: galleryVC)
        window?.makeKeyAndVisible()
        return true
    }
}

