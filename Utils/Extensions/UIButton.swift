//
//  UIButton.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation
import UIKit

extension UIButton {
    static func createRoundedCustomButton(posX: CGFloat, posY: CGFloat, icon: String) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: posX, y: posY, width: 50, height: 50)
        button.setImage(UIImage(named: icon)?.withTintColor(.black), for: .normal)
        button.backgroundColor = .systemGray4
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = button.frame.size.width/2
        
        return button
    }
}
