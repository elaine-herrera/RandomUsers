//
//  UsersResponse.swift
//  RandomUsers
//
//  Created by Elaine Herrera on 13/7/22.
//

import Foundation

struct UsersResponse: Decodable {
  let users: [User]
  let info: Info
  
  enum CodingKeys: String, CodingKey {
    case users = "results"
    case info
  }
}

struct Info: Decodable{
    let seed: String?
    let results: Int
    let page: Int
    let version: String?
}
