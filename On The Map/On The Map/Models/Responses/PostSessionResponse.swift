//
//  PostSessionResponse.swift
//  On The Map
//
//  Created by RhaXiel on 11/7/22.
//

import Foundation

struct PostSessionResponse: Codable{
    let account: Account
    let session: Session
}

struct Account: Codable{
    let registered: Bool
    let key: String
}

struct Session: Codable{
    let id: String
    let expiration: String
}
