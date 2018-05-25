//
//  HTTPStatusCode.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int {
    
    //MARK: 2xx Success
    case ok = 200
    
    //MARK: 4xx Client Error
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case new = 405
    case generalError = 418
    case validation = 422
    
    //MARK: 5xx Server Error
    case internalServerError = 500
    
    //MARK: - Computed properties
    var isSuccess: Bool {
        switch self {
        case .ok:
            return true
            
        default:
            return false
        }
    }
    
}
