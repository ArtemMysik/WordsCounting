//
//  GlobalRoute.swift
//  WordsCount
//
//  Created by   Artem on 25.05.18.
//  Copyright © 2018   Artem. All rights reserved.
//

import Foundation
import UIKit

enum GlobalRouteScreenType {
    case login
    case wordsCount
}

struct GlobalRoute {
    
    static func setupFirstScreen() {
        
    }
    
    static func setScreen(type: GlobalRouteScreenType) {
        var storyboardID = String()
        var sceneID = String()
        
        switch type {
        case .login:
            storyboardID  = StoryboardConstants.StoryboardID.main
            sceneID = StoryboardConstants.SceneID.loginNavigation
            
        case .wordsCount:
            storyboardID  = StoryboardConstants.StoryboardID.wordsCount
            sceneID = StoryboardConstants.SceneID.wordsCountNavigation
        }
        
        let storyboard = UIStoryboard(name: storyboardID, bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: sceneID)
        
        GlobalRoute.setWindow(viewController: vc)
    }
    
    //MARK: - Helpers
    fileprivate static func setWindow(viewController: UIViewController) {
        viewController.loadViewIfNeeded()
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate,
            let window = delegate.window {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
    
}
