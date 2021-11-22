//
//  RCTabViewController.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation
import UIKit

class RCTabViewController: UITabBarController {
    
    // MARK: LIFE CICLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .randomCoBlue
        tabBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: CONFIGURATION
    
    func configureViewControllers() {
        let normalVC = RCHomeViewController(favouriteMode: false)
        let favouriteVC = RCHomeViewController(favouriteMode: true)
        setViewControllers([normalVC, favouriteVC], animated: false)
    }
}
