//
//  UserInfoMapper.swift
//  RandomCo
//
//  Created by José Escudero on 13/11/21.
//

import Foundation

class UserInfoMapper {
    static func createUserInfo(from: User) -> UserInfo {
        var stringDate = ""
        if let timestamp = from.registered?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: timestamp) {
                dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
                stringDate = dateFormatter.string(from: date)
            }
        }
        let street = """
        Street: \(from.location?.street?.name ?? "")
        Number: \(from.location?.street?.number ?? 0)
        """
        let direction = """
        State: \(from.location?.state ?? "")
        City: \(from.location?.city ?? "")
        """
        let register = """
        \(stringDate)
        Ages registed: \(from.registered?.age ?? 0)
        """
        return UserInfo(
            gender: from.gender ?? "",
            name: (from.name?.first ?? "") + " " + (from.name?.last ?? ""),
            street: street,
            direction: direction,
            register: register,
            email: from.email ?? "",
            phone: from.phone ?? "",
            picture: from.picture?.large ?? "")
    }
    
    
}
