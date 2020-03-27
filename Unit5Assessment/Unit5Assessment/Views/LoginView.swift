//
//  LoginView.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/15/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    public lazy var loginLabel: UILabel = {
       let label = UILabel()
        label.text = "Log In Screen"
        label.textColor = UIColor.black
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()

    public lazy var emailLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Email: "
        return label
    }()
    
    public lazy var emailTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = " Enter email address here"
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.autocapitalizationType = .sentences
        return textField
    }()
    
    public lazy var passwordLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Password: "
        return label
    }()
    
    public lazy var passwordTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = " Enter password here"
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 10.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()
    
    public lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
    public lazy var newAccountButton: UIButton = {
       let button = UIButton()
        button.setTitle("New Account", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
//    public lazy var emailStackView: UIStackView = {
//       let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillProportionally
//        return stackView
//    }()
//
//    public lazy var passwordStackView: UIStackView = {
//       let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillProportionally
//        return stackView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpLoginLabelConstraints()
        setUpEmailLabelConstraints()
        setUpEmailTextFieldConstraints()
        setUpPasswordLabelConstraints()
        setUpPasswordTextFieldConstraints()
        setUpSignInButtonConstraints()
        setUpNewAccountButtonConstraints()
    }
    
    private func setUpLoginLabelConstraints(){
        addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([loginLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30), loginLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8), loginLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), loginLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)])
    }
    
    private func setUpEmailLabelConstraints(){
        addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([emailLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20), emailLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), emailLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05)])
        emailLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    private func setUpEmailTextFieldConstraints(){
        addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([emailTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20), emailTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8), emailTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05), emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 40)])
    }
    
    private func setUpPasswordLabelConstraints(){
        addSubview(passwordLabel)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([passwordLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20), passwordLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), passwordLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05)])
        passwordLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private func setUpPasswordTextFieldConstraints(){
        addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20), passwordTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8), passwordTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05), passwordTextField.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: 8)])
    }
    
    private func setUpSignInButtonConstraints(){
        addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30), signInButton.centerXAnchor.constraint(equalTo: centerXAnchor), signInButton.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    private func setUpNewAccountButtonConstraints(){
        addSubview(newAccountButton)
        newAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([newAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10), newAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor), newAccountButton.heightAnchor.constraint(equalToConstant: 44)])
    }
}
