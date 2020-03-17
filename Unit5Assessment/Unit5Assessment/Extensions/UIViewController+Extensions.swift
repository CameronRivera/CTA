//
//  UIViewController+Extensions.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/15/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

extension UIViewController{
    
    func showAlert(_ title: String?, _ message: String?, completion: ((UIAlertAction)->())? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    static func showViewController(storyboardName: String? = nil, viewControllerId: String? = nil, viewController: UIViewController? = nil){
        if let sb = storyboardName, let vcId = viewControllerId {
            let storyboard = UIStoryboard(name: sb, bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: vcId)
            resetWindow(newVC)
        } else if let vc = viewController{
            resetWindow(vc)
        }
    }
    
    static func showEventsController(_ user: User){
        let userDHandler = UserDefaultsHandler()
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        let eventsVC = storyboard.instantiateViewController(identifier: "EventsViewController") { coder in
            return EventsViewController(coder, userDHandler.getUserExperience(using: user.uid))
        }
        let navigationController = UINavigationController(rootViewController: eventsVC)
        resetWindow(navigationController)
        
    }
    
    static func resetWindow(_ viewController: UIViewController){
        guard let scene = UIApplication.shared.connectedScenes.first, let sceneDelegate = scene.delegate as? SceneDelegate, let window = sceneDelegate.window else {
            fatalError("Could not reset window rootViewController.")
        }
        window.rootViewController = viewController
    }
}
