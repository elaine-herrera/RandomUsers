//
//  User.swift
//  RandomUsers
//
//  Created by Elaine Herrera on 26/5/22.
//

import Foundation

struct User: Codable{
    let name: Name?
    let location: Location?
    let email: String?
    let picture: Pictures?
    
    func fullName() -> String?{
        guard let title = name?.title, let first = name?.first, let last = name?.last else { return nil }
        return "\(title) \(first) \(last)"
    }
}

struct Name: Codable {
    let title: String?
    let first: String?
    let last: String?
}

struct Location: Codable {
    let coordinates: Coordinates?
    let city: String?
    let state: String?
    let country: String?
}

struct Coordinates: Codable {
    let latitude: String?
    let longitude: String?
}

struct Pictures: Codable {
    let thumbnail: String?
}
