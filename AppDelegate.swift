//
//  AppDelegate.swift
//  Obserwator
//
//  Created by Kamil Chmielewski on 21/04/2020.
//  Copyright © 2020 Kamil Chmielewski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Make sure the app always launches with a landscape-right orientation.
    var orientationMask = UIInterfaceOrientationMask.landscapeRight

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        orientationMask
    }

}
