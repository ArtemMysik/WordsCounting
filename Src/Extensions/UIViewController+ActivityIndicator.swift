//
//  UIViewController+ActivityIndicator.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func displayActivityIndicator(on view : UIView) -> UIView {
        let container: UIView = UIView()
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.clear
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2.0,
                y: loadingView.frame.size.height / 2.0)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        view.addSubview(container)
        actInd.startAnimating()
        
        return container
    }
    
    class func removeActivityIndicator(_ activityView: UIView) {
        DispatchQueue.main.async {
            activityView.removeFromSuperview()
        }
    }
    
}
