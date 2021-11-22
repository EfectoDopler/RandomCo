//
//  Array.swift
//  RandomCo
//
//  Created by José Escudero on 12/11/21.
//

import Foundation

extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
