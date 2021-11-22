//
//  RCMockManager.swift
//  RandomCo
//
//  Created by José Escudero on 13/11/21.
//

import Foundation

class RCMockManager {
    
    // MARK: - LOAD USERS JSON
    
    func loadUsers() -> [User] {
        let data = readFile(file: "Users")
        if let jsonData = data {
            do {
                let decodedData = try JSONDecoder().decode(RCUserResponsemodel.self,
                                                           from: jsonData)
                return decodedData.results ?? [User]()
            } catch {
                return [User]()
            }
        } else {
            return [User]()
        }
    }
    
    // MARK: - Read JSON files
    
    private func readFile(file: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: file, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
