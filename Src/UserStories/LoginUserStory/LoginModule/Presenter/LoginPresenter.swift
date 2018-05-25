//
//  LoginPresenter.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

protocol LoginViewOutput {
    func triggerTextFieldChange(type: LoginFieldType, text: String?)
    func triggerLoginTouch()
}

class LoginPresenter: LoginViewOutput {
    
    //MARK: - Properties
    weak var view: LoginViewInput!
    fileprivate var loginItem = LoginUserInfo()
    fileprivate var errorWorker = LoginErrorWorker()
    
    //MARK: - Life Cycle
    required init(view: LoginViewInput) {
        self.view = view
    }
    
    //MARK: - LoginViewOutput
    func triggerTextFieldChange(type: LoginFieldType, text: String?) {
        switch type {
        case .email:
            loginItem.email = text ?? String()
            
        case .password:
            loginItem.password = text ?? String()
        }
    }
    
    func triggerLoginTouch() {
        proceedLogin()
    }
    
}

//MARK: - Extensions

//MARK: - ApiClient
extension LoginPresenter {
    
    fileprivate func proceedLogin() {
        APIClient.shared.login(email: loginItem.email, password: loginItem.password) { [weak self] (response) in
            switch response {
            case .success(_):
                GlobalRoute.setScreen(type: .wordsCount)
                
            case .errors(let errors):
                self?.proceedErrors(errors)
                
            case .fail(let message):
                self?.view.showError(message)
            }
        }
    }
    
    //MARK: - Helpers
    private func proceedErrors(_ errors: [DataResponseError]) {
        checkError(errors: errors, type: .email)
        checkError(errors: errors, type: .password)
    }
    
    private func checkError(errors: [DataResponseError], type: LoginFieldType) {
        if let error = errorWorker.findErrorIn(errors: errors, type: type) {
            view.changeVisibilityErrrorLabel(type: type, isHidden: false, text: error)
        } else {
            view.changeVisibilityErrrorLabel(type: type, isHidden: true, text: nil)
        }
    }
    
}
