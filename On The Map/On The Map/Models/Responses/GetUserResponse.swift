//
//  UserRequest.swift
//  On The Map
//
//  Created by RhaXiel on 11/7/22.
//

import Foundation

/*
struct GetUserReponse: Codable {
    let lastName: String
    let socialAccounts: [String]
    let mailingAddress: String?
    let cohortKeys: [String]
    let signature: String?
    let stripeCustomerId: String?
    let guardObject: GuardObject?
    let facebookId : String?
    let timezone : String?
    let sitePreferences: String?
    let ocuppation: String?
    let image: String?
    let firstName: String
    let jabberId: String?
    let languages: [String]?
    let badges: [String]
    let location: String?
    let externalServicePassword: String?
    let principals: [String]?
    let enrollments: [String]?
    let email: Email
    let websiteUrl: String?
    let externalAccounts: [String]?
    let bio: String?
    let coachingData: String?
    let tags: [String]?
    let affiliateProfiles: [String]?
    let hasPassword: Bool
    let emailPreferences: String?
    let resume: String?
    let key: String
    let nickname: String
    let employerSharing: Bool
    let memberships: [String]?
    let zendeksId: Bool?
    let registered: Bool
    let linkedInUrl: String?
    let googleid: String?
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case socialAccounts = "social_accounts"
        case mailingAddress = "mailing_address"
        case cohortKeys = "_cohort_keys"
        case signature = "signature"
        case stripeCustomerId = "_stripe_customer_id"
        case guardObject = "guard"
        case facebookId  = "_facebook_id"
        case timezone  = "timezone"
        case sitePreferences = "site_preferences"
        case ocuppation = "occupation"
        case image = "_image"
        case firstName = "first_name"
        case jabberId = "jabber_id"
        case languages = "languages"
        case badges = "_badges"
        case location = "location"
        case externalServicePassword = "external_service_password"
        case principals = "_principals"
        case enrollments = "_enrollments"
        case email = "email"
        case websiteUrl = "website_url"
        case externalAccounts = "external_accounts"
        case bio = "bio"
        case coachingData = "coaching_data"
        case tags = "tags"
        case affiliateProfiles = "_affiliate_profiles"
        case hasPassword = "_has_password"
        case emailPreferences = "email_preferences"
        case resume = "_resume"
        case key = "key"
        case nickname = "nickname"
        case employerSharing = "employee_sharing"
        case memberships = "_memberships"
        case zendeksId = "zendesk_id"
        case registered = "_registered"
        case linkedInUrl = "linkedin_url"
        case googleid = "_google_id"
        case imageUrl = "_image_url"
    }
}

struct GuardObject: Codable{
    let allowedBehaviors: [String]
}

struct Email: Codable{
    let address: String
    let verified: Bool
    let verificationCodeSent: Bool
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case verified = "_verified"
        case verificationCodeSent = "_verification_code_sent"
    }
}
 */

struct GetUserReponse: Codable {
    let user: User
}

struct GuardObject: Codable{
    let allowedBehaviors: [String]
}

struct User: Codable{
    let bio: String?
    //let lastName: String?
    //let firstName: String?
    let registered: Bool?
    let linkedInUrl: String?
    let imageUrl: String?
    let guardObject: GuardObject?
    let location: String?
    let key: String
    let timezone : String?
    let nickname: String?
    let websiteUrl: String?
    let ocuppation: String?
    
    
    enum CodingKeys: String, CodingKey {
        case bio = "bio"
        //case lastName = "last_name"
        //case firstName = "first_name"
        case registered = "_registered"
        case linkedInUrl = "linkedin_url"
        case imageUrl = "_image_url"
        case guardObject = "guard"
        case location = "location"
        case key = "key"
        case timezone  = "timezone"
        case nickname = "nickname"
        case websiteUrl = "website_url"
        case ocuppation = "occupation"
    }
}


//Another sample response

/*
 "user": {
       "bio": null,
       "_registered": true,
       "linkedin_url": null,
       "_image": null,
       "guard": {
         "allowed_behaviors": ["register", "view-public", "view-short"]
       },
       "location": null,
       "key": "22831410629",
       "timezone": null,
       "_image_url": null,
       "nickname": "",
       "website_url": null,
       "occupation": null
     }
 */

//Sample response
/*
"last_name": "Runolfsdottir",
  "social_accounts": [],
  "mailing_address": null,
  "_cohort_keys": [],
  "signature": null,
  "_stripe_customer_id": null,
  "guard": {},
  "_facebook_id": null,
  "timezone": null,
  "site_preferences": null,
  "occupation": null,
  "_image": null,
  "first_name": "Drake",
  "jabber_id": null,
  "languages": null,
  "_badges": [],
  "location": null,
  "external_service_password": null,
  "_principals": [],
  "_enrollments": [],
  "email": {
    "address": "drake.runolfsdottir@onthemap.udacity.com",
    "_verified": true,
    "_verification_code_sent": true
  },
  "website_url": null,
  "external_accounts": [],
  "bio": null,
  "coaching_data": null,
  "tags": [],
  "_affiliate_profiles": [],
  "_has_password": true,
  "email_preferences": null,
  "_resume": null,
  "key": "62132044",
  "nickname": "Drake Runolfsdottir",
  "employer_sharing": false,
  "_memberships": [],
  "zendesk_id": null,
  "_registered": false,
  "linkedin_url": null,
  "_google_id": null,
  "_image_url": "https://robohash.org/udacity-62132044"
*/
