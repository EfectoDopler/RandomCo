//
//  RCBaseViewController.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation
import UIKit
import Combine

class RCBaseViewController: UIViewController {
    
    // MARK: - COMBINE SUBSCRIPTION
    
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Attributes declaration
    
    var loader: RCLoader!
    
    // MARK: - LIFE CICLE
    override func viewDidLoad() {
        super.viewDidLoad()
        createLoaderView()
        bindComponentsToViewModel()
    }

    // MARK: - LOADER VIEW CONFIGURATION

    private func createLoaderView() {
        loader = RCLoader.sharedInstance
    }
    
    func showLoaderView() {
        loader.showIndicator()
    }
   
    func hideLoaderView() {
        loader.hideIndicator()
    }
    
    // MARK: - BIND COMPONENTS
    
    func bindComponentsToViewModel() { }
}
