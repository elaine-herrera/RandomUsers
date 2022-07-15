//
//  UserServices.swift
//  RandomUsers
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import Foundation
import Moya

enum UserServices {
    case userList(userCount: Int, page: Int)
}

extension UserServices: TargetType {
    var baseURL: URL {
        return URL(string: "https://randomuser.me/api")!
    }

    var path: String {
        return "/"
    }

    var method: Moya.Method {
        .get
    }

    var sampleData: Data {
        switch self {
        default:
            guard let url = Bundle.main.url(forResource: "results", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }

    var task: Task {
        switch self {
        case let .userList(userCount, page):
            return .requestParameters(parameters: ["results": userCount, "page": page, "seed": "foo", "inc": "name,email,location,picture"], encoding:  URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        nil
    }

}
