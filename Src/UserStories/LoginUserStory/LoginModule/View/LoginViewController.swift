//
//  LoginViewController.swift
//  WordsCount
//
//  Created by   Artem on 21.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Proeprties
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextField()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Private Methods
    fileprivate func setupButtons() {
        UIDecorator.initialButtonSetup(loginButton, isBorder: true)
        UIDecorator.initialButtonSetup(signUpButton, isBorder: false)
    }
    
    fileprivate func setupTextField() {
        UIDecorator.initialTextFieldSetup(loginTextField, placeholder: TextConstants.Login.emailPlaceholder)
        UIDecorator.initialTextFieldSetup(passwordTextField, placeholder: TextConstants.Login.passwordPlaceholder)
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }

}

//MARK: - Extensions

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
