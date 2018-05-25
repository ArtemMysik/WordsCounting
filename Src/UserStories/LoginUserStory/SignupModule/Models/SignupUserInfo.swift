//
//  SignupUserInfo.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

struct SignupUserInfo {
    var nickname: String
    var email: String
    var password: String
}

//MARK: - Extensions

//MARK: - Custom constructors
extension SignupUserInfo {
    
    init() {
        nickname = String()
        email = String()
        password = String()
    }
    
}
