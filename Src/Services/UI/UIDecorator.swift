//
//  UIDecorator.swift
//  WordsCount
//
//  Created by   Artem on 22.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import UIKit

struct UIDecorator {
    
    //MARK: - Public Static Methods
    static func initialButtonSetup(_ button: UIButton, isBorder: Bool) {
        if isBorder {
            button.backgroundColor = .clear
            button.layer.cornerRadius = button.bounds.size.height/2.0
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        button.setTitle(button.title(for: .normal)?.uppercased(), for: .normal)
    }
    
    static func initialTextFieldSetup(_ textField: UITextField, placeholder: String) {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: attributes)
    }
    
}
