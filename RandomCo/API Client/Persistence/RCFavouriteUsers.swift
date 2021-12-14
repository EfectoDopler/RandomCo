//
//  RCFavouriteUsers.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation
import Combine

class RCFavouriteUsers: ObservableObject {
    
    // MARK: - VARIABLE DECLARATION
    
    static var shared = RCFavouriteUsers()
    @Published private(set) var results: [User] = []
    
    func getFavouriteUsers() -> [User] {
        return results
    }
    
    func userIsFavourite(user: User) -> Bool {
        for result in results where user == result {
            return true
        }
        return false
    }
    
    func addFavourite(user: User) {
        results.append(user)
    }
    
    func removeFavourite(user: User) {
        var index = 0
        
        for result in results {
            if user == result {
                break
            }
            index = index + 1
        }
        
        results.remove(at: index)
    }
    
    func clean() {
        results = [User]()
    }
}
