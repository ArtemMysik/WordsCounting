//
//  APIClient.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation
import Alamofire

typealias UserResponse = (DataResponseRessult<User>) -> Void

class APIClient {
    static let shared = APIClient()
    fileprivate let httpClient = HTTPClient()
    private (set) var user: User?
    
    private init() {}
}

//MARK: - Extensions

//MARK: - HTTPClient
extension APIClient {
    
    //MARK: - Public Methods
    func login(email: String, password: String, done: @escaping UserResponse) {
        let router = Router.apiLogin(email: email, password: password)
        httpClient.request(router: router) { [weak self] (result: DataResponseRessult<User>) in
            self?.proceedUserResult(result: result, done: done)
        }
    }
    
    func signUp(nickname: String, email: String, password: String, done: @escaping UserResponse) {
        let router = Router.apiSignup(nickname: nickname, email: email, password: password)
        httpClient.request(router: router) { [weak self] (result: DataResponseRessult<User>) in
            self?.proceedUserResult(result: result, done: done)
        }
    }
    
    //MARK: - Helpers
    fileprivate func proceedUserResult(result: DataResponseRessult<User>, done: @escaping UserResponse) {
        if case .success(let user) = result {
            self.user = user
        }
        
        done(result)
    }
    
}
