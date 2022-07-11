//
//  PostStudentLocationRequest.swift
//  On The Map
//
//  Created by RhaXiel on 11/7/22.
//

import Foundation

struct PostStudentLocationRequests : Codable {
    
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    
}
