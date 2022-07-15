//
//  UserProvider.swift
//  RandomUsers
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import Foundation
import Moya

class UserProvider: UserProviderProtocol {
    private let service: MoyaProvider<UserServices>
    
    init(service: MoyaProvider<UserServices>) {
        self.service = service
    }
    
    func listOfUsers(userCount: Int, page: Int, completion: @escaping ((Result<[User], ClientError>) -> Void) ) {
        service.request(.userList(userCount: userCount, page: page)) { result in
            switch result{
            case .success(let response):
                let data = response.data
                let statusCode = response.statusCode
                guard statusCode == 200 else {
                    completion(.failure(ClientError.invalidServerResponseError))
                    return
                }
                guard let decodedResponse = try? JSONDecoder().decode(UsersResponse.self, from: data) else {
                    completion(.failure(ClientError.parseError))
                    return
                }
                let users = decodedResponse.users
                completion(.success(users))
                break
            case .failure(let error):
                completion(.failure(ClientError.httpError(error: error.localizedDescription)))
                break
            }
        }
    }
    
    
}
