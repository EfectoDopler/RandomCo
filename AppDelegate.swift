//
//  AppDelegate.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let home = RCTabViewController()
        home.configureViewControllers()
        let navigationController = UINavigationController(rootViewController: home)
        navigationController.navigationBar.barTintColor = .randomCoBlue
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.topItem?.title = "RandomCo"
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}

