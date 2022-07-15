//
//  ClientError.swift
//  RandomUsers
//
//  Created by Elaine Herrera on 14/7/22.
//

import Foundation

enum ClientError: Error {
    case invalidServerResponseError
    case parseError
    case anyError
    case httpError(error: String)
}

extension ClientError: LocalizedError{
    public var errorDescription: String?{
        switch self {
        case .invalidServerResponseError:
            return "Invalid Server Response"
        case .parseError:
            return "Error parsing response data"
         case .anyError:
            return "An error ocurred"
        case .httpError(let error):
            return error
        }
    }
}
