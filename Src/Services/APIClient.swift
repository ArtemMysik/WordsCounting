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
typealias EmptyModelResponse = (DataResponseRessult<EmptySuccess>) -> Void

class APIClient {
    static let shared = APIClient()
    fileprivate let httpClient = HTTPClient()
    fileprivate (set) var user: User?
    fileprivate (set) var token: String?
    
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
    
    func getText(done: @escaping EmptyModelResponse) {
        let router = Router.apiGetText
        httpClient.request(router: router, completion: done)
    }
    
    func logout() {
        let router = Router.apiLogout
        httpClient.request(router: router) { (result: DataResponseRessult<EmptySuccess>) in }
        
        removeTokenFromKeyChain()
        token = nil
        user = nil
        GlobalRoute.setScreen(type: .login)
    }
    
    //MARK: - Helpers
    fileprivate func proceedUserResult(result: DataResponseRessult<User>, done: @escaping UserResponse) {
        if case .success(let user) = result {
            self.user = user
            self.token = self.user?.accessToken
            self.user?.accessToken = String()
            saveTokenWithinKeyChain()
        }
        
        done(result)
    }
    
}

//MARK: - Keychain
extension APIClient {
    
    fileprivate func removeTokenFromKeyChain() {
        let tokenItem = KeychainValueItem(service: KeychainConfiguration.serviceName,
                                          identifier: KeychainConfiguration.account,
                                          accessGroup: KeychainConfiguration.accessGroup)
        do {
            try tokenItem.deleteItem()
            UserDefaults.standard.removeObject(forKey: "user")
        } catch {
            print("Error removing user from keychain - \(error)")
        }
    }
    
    func loadTokenFromKeyChain() -> Bool {
        do {
            let tokenItem = KeychainValueItem(service: KeychainConfiguration.serviceName,
                                              identifier: KeychainConfiguration.account,
                                              accessGroup: KeychainConfiguration.accessGroup)
            
            let token = try tokenItem.readValue()
            self.token = token
            
            return true
        } catch {
            print("Error reading user from keychain - \(error)")
            removeTokenFromKeyChain()
            
            return false
        }
        
    }
    
    fileprivate func saveTokenWithinKeyChain() {
        do {
            let tokenItem = KeychainValueItem(service: KeychainConfiguration.serviceName,
                                              identifier: KeychainConfiguration.account,
                                              accessGroup: KeychainConfiguration.accessGroup)
            guard let token = token else {
                return
            }
            
            try tokenItem.saveValue(token)
            
        } catch {
            print("Error saving user in keychain - \(error)")
        }
    }
    
}
