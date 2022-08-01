//
//  UserRequest.swift
//  On The Map
//
//  Created by RhaXiel on 11/7/22.
//

import Foundation

struct GetUserResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
