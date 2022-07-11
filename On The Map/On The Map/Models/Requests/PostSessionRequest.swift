//
//  Session.swift
//  On The Map
//
//  Created by RhaXiel on 11/7/22.
//

import Foundation

struct PostSessionRequest: Codable{
    let udacity: Udacity
}

struct Udacity: Codable {
    let username: String
    let password: String
}
