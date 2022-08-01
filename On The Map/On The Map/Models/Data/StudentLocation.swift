//
//  MKPointAnnotation.swift
//  On The Map
//
//  Created by RhaXiel on 10/7/22.
//

import Foundation

struct StudentLocation: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
