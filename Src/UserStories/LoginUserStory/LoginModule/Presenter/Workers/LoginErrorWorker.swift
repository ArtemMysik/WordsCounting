//
//  LoginErrorWorker.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

struct LoginErrorWorker {
    
    //MARK: - Public Methods
    func findErrorIn(errors: [DataResponseError], type: LoginFieldType) -> String? {
        var field = String()
        
        switch type {
        case .email:
            field = WebConstants.ErrorName.email
            
        case .password:
            field = WebConstants.ErrorName.password
        }
        
        return errors.index(where: {$0.name == field}).flatMap({errors[$0]})?.message
    }
    
}
