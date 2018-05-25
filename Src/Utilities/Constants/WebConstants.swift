//
//  WebConstants.swift
//  WordsCount
//
//  Created by   Artem on 21.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

enum WebConstants {
  
  enum Router {
    //MARK: - Headers
    static let authorizationHeader = "Authorization"
    static let contentTypeHeader = "Content-Type"
    
    //MARK: - Header's values
    static let tokenPrefixValue = "Bearer "
    static let contentTypeJSONValue = "application/json"
    
    //MARK: - Main URLs and Folders
    static let baseURL = "https://apiecho.cf"
    
    private static let apiFolder = "/api"
    private static let getFolder = "/get"
    
    //MARK: - Paths
    private static let getPath = Router.apiFolder + Router.getFolder
    
    static let loginPath = Router.apiFolder + "/login/"
    static let logoutPath = Router.apiFolder + "/logout/"
    static let signupPath = Router.apiFolder + "/signup/"
    static let textPath = Router.getPath + "/text/"
    static let personPath = Router.getPath + "/person/"
    
    //MARK: - Parameters
    static let localeKey = "locale"
    static let emailKey = "email"
    static let passwordKey = "password"
    static let nicknameKey = "name"
  }
    
    enum FailMessages {
        static let internetConnection = "Internet connection error"
        static let unknown = "Unknown error"
        static let responseError = "Response error"
        static let internalError = "Internal error"
    }
  
    enum HTTPClient {
        static let dataKey = "data"
        static let errorsKey = "errors"
    }
    
    enum ErrorName {
        static let email = "email"
        static let password = "password"
        static let nickname = "nickname"
    }
}
