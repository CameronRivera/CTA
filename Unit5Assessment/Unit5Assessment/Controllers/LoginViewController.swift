//
//  LoginViewController.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/15/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUp()
    }
    
    private func setUp(){
    }
}
