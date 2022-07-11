//
//  UserRequest.swift
//  On The Map
//
//  Created by RhaXiel on 11/7/22.
//

import Foundation

struct GetUserReponse: Codable {
    /*
    let lastName: String
    let socialAccounts: [String]
    let mailingAddress: String?
    let cohortKeys: [String]
    let signature: String?
    */
    let bio : String?
    let registered: Bool
    let linkedinUrl: String?
    let image: String?
    let guardObject: GuardObject
    let location: String?
    let key: String
    let timezone: String?
    let imageUrl: String?
    let nickname: String?
    let websiteUrl: String?
    let occupation: String?
}

struct GuardObject: Codable{
    let allowedBehaviors: [String]
}
