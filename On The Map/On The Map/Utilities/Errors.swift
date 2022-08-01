//
//  Errors.swift
//  On The Map
//
//  Created by RhaXiel on 14/7/22.
//

import Foundation


public enum LoginError: Error {
    case invalidCredentials(String)
}

extension LoginError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials(let message):
            return NSLocalizedString(message, comment: "Login Error")
        }
    }
}
