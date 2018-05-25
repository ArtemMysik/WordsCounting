//
//  LoginViewController.swift
//  WordsCount
//
//  Created by   Artem on 21.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import UIKit

protocol LoginViewInput: ActivityShowable {
    func changeVisibilityErrrorLabel(type: LoginFieldType, isHidden: Bool, text: String?)
    func showError(_ string: String)
}

class LoginViewController: UIViewController, AlertMessageShowing {
    
    //MARK: - Proeprties
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var presenter: LoginViewOutput!
    weak var activityIndicator: UIView?
    
    //MARK: - Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = LoginPresenter(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTextFields()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Private Methods
    fileprivate func setupButtons() {
        UIDecorator.initialButtonSetup(loginButton, isBorder: true)
        UIDecorator.initialButtonSetup(signUpButton, isBorder: false)
    }
    
    fileprivate func setupTextFields() {
        UIDecorator.initialTextFieldSetup(emailTextField, placeholder: TextConstants.Login.emailPlaceholder)
        UIDecorator.initialTextFieldSetup(passwordTextField, placeholder: TextConstants.Login.passwordPlaceholder)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - Interfaccce Handlers
    @IBAction func didTouchLoginButton(_ sender: UIButton) {
        presenter.triggerLoginTouch()
    }
    
}

//MARK: - Extensions

//MARK: - LoginViewInput
extension LoginViewController: LoginViewInput {
    
    func changeVisibilityErrrorLabel(type: LoginFieldType, isHidden: Bool, text: String?) {
        switch type {
        case .email:
            emailErrorLabel.text = text
            emailErrorLabel.isHidden = isHidden
            
        case .password:
            passwordErrorLabel.text = text
            passwordErrorLabel.isHidden = isHidden
        }
    }
    
    func showError(_ string: String) {
        showAlert(message: string, handler: nil)
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            presenter.triggerLoginTouch()
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField === emailTextField {
            presenter.triggerTextFieldChange(type: .email, text: textField.text)
        } else {
            presenter.triggerTextFieldChange(type: .password, text: textField.text)
        }
    }
    
}
