//
//  User.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: Int?
    var name: String
    var email: String
    var accessToken: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "uid"
        case accessToken = "access_token"
        
        case name
        case email
    }
}
