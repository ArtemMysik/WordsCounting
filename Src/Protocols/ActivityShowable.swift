//
//  ActivityShowable.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityShowable: class {
    weak var activityIndicator: UIView? {get set}
    func startActivityIndicator()
    func stopActivityIndicator()
}

extension ActivityShowable where Self: UIViewController {
    
    func startActivityIndicator() {
        if activityIndicator == nil {
            activityIndicator = UIViewController.displayActivityIndicator(on: view)
        }
    }
    
    func stopActivityIndicator() {
        if let view = activityIndicator {
            UIViewController.removeActivityIndicator(view)
        }
    }
    
}
