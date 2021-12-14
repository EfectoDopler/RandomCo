//
//  User.swift
//  RandomCo
//
//  Created by José Escudero on 13/11/21.
//

import Foundation

struct User: Codable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.gender == rhs.gender
            && lhs.name?.first == rhs.name?.first
            && lhs.name?.last == rhs.name?.last
            && lhs.location?.street?.number == rhs.location?.street?.number
            && lhs.location?.street?.name == rhs.location?.street?.name
            && lhs.location?.city == rhs.location?.city
            && lhs.location?.state == rhs.location?.state
            && lhs.location?.coordinates?.latitude == rhs.location?.coordinates?.latitude
            && lhs.location?.coordinates?.longitude == rhs.location?.coordinates?.longitude
            && lhs.email == rhs.email
            && lhs.login?.username == rhs.login?.username
            && lhs.login?.password == rhs.login?.password
            && lhs.registered?.date == rhs.registered?.date
            && lhs.registered?.age == rhs.registered?.age
            && lhs.phone == rhs.phone
            && lhs.id?.name == rhs.id?.name
            && lhs.id?.value == rhs.id?.value
            && lhs.picture?.thumbnail == rhs.picture?.thumbnail
            && lhs.picture?.medium == rhs.picture?.medium
            && lhs.picture?.large == rhs.picture?.large
    }
    
    let gender: String?
    let name: Name?
    let location: Location?
    let email: String?
    let login: Login?
    let registered: Registered?
    let phone: String?
    let id: Id?
    let picture: Picture?
    
    init(gender: String?, name: Name?, location: Location?, email: String?, login: Login?, registered: Registered?, phone: String?, id: Id?, picture: Picture?) {
        self.gender = gender
        self.name = name
        self.location = location
        self.email = email
        self.login = login
        self.registered = registered
        self.phone = phone
        self.id = id
        self.picture = picture
    }
}

struct Picture: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?
}

struct Id: Codable {
    let name: String?
    let value: String?
}

struct Registered: Codable {
    let date: String?
    let age: Int?
}

struct Login: Codable {
    let username: String?
    let password: String?
}

struct Location: Codable {
    let street: Street?
    let city: String?
    let state: String?
    let coordinates: Coordinate?
}

struct Coordinate: Codable {
    let latitude: String?
    let longitude: String?
    
    /*
     This code have been adapted from this github project:
     https://github.com/raywenderlich/swift-algorithm-club/blob/master/HaversineDistance/HaversineDistance.playground/Contents.swift
     */
    static func calculateDistance(coord1: Coordinate, coord2: Coordinate) -> Double {
        let radius = 6367444.7
        let haversin = { (angle: Double) -> Double in
            return (1 - cos(angle))/2
        }
        
        let ahaversin = { (angle: Double) -> Double in
            return 2*asin(sqrt(angle))
        }
        
        let dToR = { (angle: Double) -> Double in
            return (angle / 360) * 2 * .pi
        }
        
        if let lat1 = coord1.latitude,
            let lon1 = coord1.longitude,
            let lat2 = coord2.latitude,
            let lon2 = coord2.longitude {
                let latDouble1 = dToR(Double(lat1) ?? 0.0)
                let lonDouble1 = dToR(Double(lon1) ?? 0.0)
                let latDouble2 = dToR(Double(lat2) ?? 0.0)
                let lonDouble2 = dToR(Double(lon2) ?? 0.0)
                return radius * ahaversin(haversin(latDouble2 - latDouble1) + cos(latDouble1) * cos(latDouble2) * haversin(lonDouble2 - lonDouble1))
        }
        
        return 0.0
    }
}

struct Street: Codable {
    let number: Int?
    let name: String?
}

struct Name: Codable {
    let first: String?
    let last: String?
}
