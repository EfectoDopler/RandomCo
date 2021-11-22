//
//  RCUserInfoViewController.swift
//  RandomCo
//
//  Created by José Escudero on 13/11/21.
//

import UIKit
import Combine
import Kingfisher

class RCUserInfoViewController: RCBaseViewController {
    
    // MARK: - VARIABLE DECLARATION
    
    private var viewModel: RCUserInfoViewModel
    
    @IBOutlet weak var userInfoImageView: UIImageView!
    @IBOutlet weak var userInfoNameLabel: UILabel!
    @IBOutlet weak var userInfoGenderLabel: UILabel!
    @IBOutlet weak var userInfoRegisterLabel: UILabel!
    @IBOutlet weak var userInfoDirectionLabel: UILabel!
    @IBOutlet weak var userInfoStreetLabel: UILabel!
    @IBOutlet weak var userInfoEmailLabel: UILabel!
    @IBOutlet weak var userInfoPhoneLabel: UILabel!
    
    // MARK: - CONSTRUCTOR
    
    init(userInfo: UserInfo) {
        viewModel = RCUserInfoViewModel(userInfo: userInfo)
        super.init(nibName: "RCUserInfoViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LIFE CICLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - BIND VIEW COMPONENTS WITH VIEWMODEL
    
    override func bindComponentsToViewModel() {
        subscriptions = [
            viewModel.userInfo.$name.assign(to: \.text!, on: userInfoNameLabel),
            viewModel.userInfo.$gender.assign(to: \.text!, on: userInfoGenderLabel),
            viewModel.userInfo.$register.assign(to: \.text!, on: userInfoRegisterLabel),
            viewModel.userInfo.$direction.assign(to: \.text!, on: userInfoDirectionLabel),
            viewModel.userInfo.$street.assign(to: \.text!, on: userInfoStreetLabel),
            viewModel.userInfo.$email.assign(to: \.text!, on: userInfoEmailLabel),
            viewModel.userInfo.$phone.assign(to: \.text!, on: userInfoPhoneLabel),
        ]
        
        viewModel.userInfo.$picture.sink {
            [weak self] imageURL in
            if let url = URL.init(string: imageURL) {
                self?.userInfoImageView.kf.setImage(with: url)
            }
        }
        .store(in: &subscriptions)
    }
}
