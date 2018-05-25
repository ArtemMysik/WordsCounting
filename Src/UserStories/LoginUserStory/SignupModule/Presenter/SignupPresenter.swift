//
//  SignupPresenter.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation

protocol SignupViewOutput {
    func triggerTextFiledChange(type: SignupFieldType, text: String?)
    func triggerSignupButtonTouch()
}

class SignupPresenter: SignupViewOutput {
    
    //MARK: - Properties
    weak var view: SignupViewInput!
    fileprivate var signupItem = SignupUserInfo()
    fileprivate var errorWorker = SignupErrorWorker()
    
    //MARK: - Life Cycle
    required init(view: SignupViewInput) {
        self.view = view
    }
    
    //MARK: - SignupViewOutput
    func triggerTextFiledChange(type: SignupFieldType, text: String?) {
        switch type {
        case .nickname:
            signupItem.nickname = text ?? String()
            
        case .email:
            signupItem.email = text ?? String()
            
        case .password:
            signupItem.password = text ?? String()
        }
    }
    
    func triggerSignupButtonTouch() {
        proceedSignup()
    }
    
}

//MARK: - Extensions

//MARK: - APIClient
extension SignupPresenter {
    
    fileprivate func proceedSignup() {
        APIClient.shared.signUp(nickname: signupItem.nickname,
                                email: signupItem.email,
                                password: signupItem.password) { [weak self] (result) in
                                    switch result {
                                    case .success(_):
                                        GlobalRoute.setScreen(type: .wordsCount)
                                        
                                    case .fail(let message):
                                        self?.view.showError(message)
                                        
                                    case .errors(let errors):
                                        self?.proceedErrors(errors)
                                    }
        }
    }
    
    //MARK: - Helpers
    private func proceedErrors(_ errors: [DataResponseError]) {
        checkError(errors: errors, type: .nickname)
        checkError(errors: errors, type: .email)
        checkError(errors: errors, type: .password)
    }
    
    private func checkError(errors: [DataResponseError], type: SignupFieldType) {
        if let error = errorWorker.findErrorIn(errors: errors, type: type) {
            view.changeVisibilityErrrorLabel(type: type, isHidden: false, text: error)
        } else {
            view.changeVisibilityErrrorLabel(type: type, isHidden: true, text: nil)
        }
    }
    
}
