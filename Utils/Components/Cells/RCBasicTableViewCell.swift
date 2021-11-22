//
//  RCBasicTableViewCell.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import UIKit
import Kingfisher

protocol RCBasicTableViewCellProtocol {
    func imagePressed(id: Int)
    func removeItem(id: Int)
    func favourite(id: Int)
}

class RCBasicTableViewCell: UITableViewCell {

    // MARK: VARIABLE DECLARATION
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userEmailLabel: UILabel!
  
    @IBOutlet weak var userPhoneLabel: UILabel!
   
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var favouriteFullLeading: NSLayoutConstraint!
    
    @IBOutlet weak var favouriteMediumLeading: NSLayoutConstraint!
    
    private var id: Int = 0
    var delegate: RCBasicTableViewCellProtocol?
    
    // MARK: LIFE CICLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(imagePressed(gesture:)))
        tap.minimumPressDuration = 0
        self.userImageView.addGestureRecognizer(tap)
        self.userImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model: RCBasicTableViewCellModel) {
        userNameLabel.text = model.name
        userEmailLabel.text = model.email
        userPhoneLabel.text = model.phone
        favouriteButton.setTitle(model.favourite ? "Remove fav" : "Add fav", for: .normal)
        id = model.id
        
        if let url = URL.init(string: model.url) {
            userImageView.kf.setImage(with: url)
        }
        
        if model.favouriteMode {
            favouriteFullLeading.priority = UILayoutPriority(rawValue: 750)
            favouriteMediumLeading.priority = UILayoutPriority(rawValue: 250)
        }
    }
    
    @IBAction func removeTouchup(_ sender: Any) {
        delegate?.removeItem(id: id)
    }
    
    
    @IBAction func favouriteTouchUp(_ sender: Any) {
        delegate?.favourite(id: id)
    }
    
    @objc func imagePressed(gesture: UITapGestureRecognizer) {
        if  gesture.state == .ended {
            delegate?.imagePressed(id: id)
        }
      }
}

struct RCBasicTableViewCellModel {
    var name: String
    var email: String
    var phone: String
    var url: String
    var favourite: Bool
    var favouriteMode: Bool
    var id: Int
    
    init(name: String, email: String, phone: String, url: String, favourite: Bool, favouriteMode: Bool, id: Int) {
        self.name = name
        self.email = email
        self.phone = phone
        self.url = url
        self.favourite = favourite
        self.favouriteMode = favouriteMode
        self.id = id
    }
}
