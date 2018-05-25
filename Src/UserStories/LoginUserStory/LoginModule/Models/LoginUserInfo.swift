//
//  LoginUserInfo.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

struct LoginUserInfo {
    var email: String
    var password: String
}

//MARK: - Extensions

//MARK: - Custom constructors
extension LoginUserInfo {
    
    init() {
        email = String()
        password = String()
    }
    
}
