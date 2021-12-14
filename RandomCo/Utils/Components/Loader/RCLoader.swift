//
//  RCLoader.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation
import UIKit

class RCLoader {

    // MARK: - ATRIBUTES DECLARATION
    
    public static let sharedInstance = RCLoader()
    
    private var blurImg = UIImageView()
    private var indicator = UIActivityIndicatorView()

    // MARK: - CONSTRUCTOR
    
    private init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = .white
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.6
        indicator.style = .large
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = .systemGray4
    }
    
    // MARK: - PRESENTATION LOGIC
    
    func showIndicator() {
        DispatchQueue.main.async( execute: {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            keyWindow?.addSubview(self.blurImg)
            keyWindow?.addSubview(self.indicator)
        })
    }
    
    func hideIndicator() {
        DispatchQueue.main.async( execute: {
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
        })
    }
}
