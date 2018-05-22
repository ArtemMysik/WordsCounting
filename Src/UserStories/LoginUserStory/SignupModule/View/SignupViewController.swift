//
//  SignupViewController.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextFields()
        hideKeyboardWhenTappedAround()
        
    }
    
    //MARK: - Private Methods
    fileprivate func setupButtons() {
        UIDecorator.initialButtonSetup(signupButton, isBorder: true)
    }
    
    fileprivate func setupTextFields() {
        UIDecorator.initialTextFieldSetup(nicknameTextField, placeholder: TextConstants.Login.nicknamePlaceholder)
        UIDecorator.initialTextFieldSetup(emailTextField, placeholder: TextConstants.Login.emailPlaceholder)
        UIDecorator.initialTextFieldSetup(passwordTextField, placeholder: TextConstants.Login.passwordPlaceholder)
        
        nicknameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
}

//MARK: - Extensions

//MARK: - UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nicknameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
