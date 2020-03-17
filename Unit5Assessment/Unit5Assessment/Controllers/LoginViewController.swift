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
    private var state = AccountState.existingUser
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUp()
    }
    
    private func setUp(){
        loginView.signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        loginView.newAccountButton.addTarget(self, action: #selector(createNewAccountButtonPressed), for: .touchUpInside)
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    @objc
    private func signInButtonPressed(_ sender: UIButton){
        state = AccountState.existingUser
        unwrapEmailAndPassword()
    }
    
    @objc
    private func createNewAccountButtonPressed(_ sender: UIButton){
        state = AccountState.newUser
        unwrapEmailAndPassword()
    }
    
    private func unwrapEmailAndPassword(){
        guard let email = loginView.emailTextField.text, !email.isEmpty, let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert("Missing Fields", "One or more fields is missing, please make sure both email and password are properly filled in.")
            return
        }
        resumeLoginProcedure(email,password)
    }
    
    private func resumeLoginProcedure(_ email: String, _ password: String){
        if state == AccountState.existingUser{
            AuthenticationService.manager.signInExistingUser(email, password) { [weak self] result in
                switch result{
                case .failure(let error):
                    DispatchQueue.main.async{
                        self?.showAlert("Authentication Error", error.localizedDescription)
                    }
                case .success(let authData):
                    FirestoreService.manager.getUserData(authData.user.uid) { [weak self] result in
                        switch result{
                        case .failure(let error):
                            DispatchQueue.main.async{
                                self?.showAlert("Error Retrieving User", error.localizedDescription)
                            }
                        case .success(let user):
                            // If the state is ticketMaster, then tableView
                            // If the state is rijks, then collectionView
                            self?.changeScene(user)
                        }
                    }
                }
            }
        } else {
            let selectVC = SelectUserExperienceController(email, password)
            navigationController?.pushViewController(selectVC, animated: true)
        }
    }
    
    private func changeScene(_ user: EndUser){
        
        var experience = UserExperience.rijksMuseum
        
        if user.selectedExperience == UserExperience.rijksMuseum.rawValue {
            experience = UserExperience.rijksMuseum
        } else {
            experience = UserExperience.ticketMaster
        }
        
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: "EventsViewController", creator: { coder in
            return EventsViewController(coder, experience)
        })
        
        let navigationVC = UINavigationController(rootViewController: newVC)
        
        UIViewController.showViewController(storyboardName: nil,viewControllerId: nil,viewController: navigationVC)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
