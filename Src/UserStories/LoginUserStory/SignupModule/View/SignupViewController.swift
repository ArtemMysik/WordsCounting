//
//  SignupViewController.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import UIKit

protocol SignupViewInput: class {
    func showError(_ string: String)
    func changeVisibilityErrrorLabel(type: SignupFieldType, isHidden: Bool, text: String?)
}

class SignupViewController: UIViewController, AlertMessageShowing {
    
    //MARK: - Properties
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var nicknameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var presenter: SignupViewOutput!
    
    //MARK: - Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = SignupPresenter(view: self)
    }
    
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
        setupTextField(nicknameTextField, placeholder: TextConstants.Login.nicknamePlaceholder)
        setupTextField(emailTextField, placeholder: TextConstants.Login.emailPlaceholder)
        setupTextField(passwordTextField, placeholder: TextConstants.Login.passwordPlaceholder)
    }
    
    fileprivate func setupTextField(_ textField: UITextField, placeholder: String) {
        UIDecorator.initialTextFieldSetup(textField, placeholder: placeholder)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - Interface Handlers
    @IBAction func didTouchSignupButton(_ sender: UIButton) {
        presenter.triggerSignupButtonTouch()
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
            presenter.triggerSignupButtonTouch()
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
        if textField === nicknameTextField {
            presenter.triggerTextFiledChange(type: .nickname, text: textField.text)
        } else if textField === emailTextField {
            presenter.triggerTextFiledChange(type: .email, text: textField.text)
        } else {
            presenter.triggerTextFiledChange(type: .password, text: textField.text)
        }
    }
    
}

//MARK: - Extensions

//MARK: - SignupViewInput
extension SignupViewController: SignupViewInput {
    
    func showError(_ string: String) {
        showAlert(message: string, handler: nil)
    }
    
    func changeVisibilityErrrorLabel(type: SignupFieldType, isHidden: Bool, text: String?) {
        switch type {
        case .nickname:
            nicknameErrorLabel.isHidden = isHidden
            nicknameErrorLabel.text = text
        
        case .email:
            emailErrorLabel.isHidden = isHidden
            emailErrorLabel.text = text
            
        case .password:
            passwordErrorLabel.isHidden = isHidden
            passwordErrorLabel.text = text
        }
    }
    
}
