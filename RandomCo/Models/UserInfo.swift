//
//  UserInfo.swift
//  RandomCo
//
//  Created by José Escudero on 13/11/21.
//

import Foundation
import Combine

class UserInfo: ObservableObject {
    @Published var gender: String
    @Published var name: String
    @Published var street: String
    @Published var direction: String
    @Published var register: String
    @Published var email: String
    @Published var phone: String
    @Published var picture: String
    
    
    init(gender: String, name: String, street: String, direction: String, register: String, email: String, phone: String, picture: String) {
        self.gender = gender
        self.name = name
        self.street = street
        self.direction = direction
        self.register = register
        self.email = email
        self.phone = phone
        self.picture = picture
    }
}
