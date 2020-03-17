//
//  SelectUserExperienceController.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import Firebase

class SelectUserExperienceController: UIViewController {

    private let userXPView = SelectUserExperienceView()
    private let experiences = ["TicketMaster","RijksMuseum"]
    private var selectedExperience = UserExperience.ticketMaster
    private let userEmail: String
    private let userPassword: String
    
    init(_ userEmail: String, _ userPassword: String){
        self.userEmail = userEmail
        self.userPassword = userPassword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = userXPView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        userXPView.pickerView.delegate = self
        userXPView.pickerView.dataSource = self
        userXPView.confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        view.backgroundColor = .systemBackground
    }
    
    @objc
    private func confirmButtonPressed(_ sender: UIButton){
        
        AuthenticationService.manager.createNewAccount(userEmail, userPassword) { [unowned self] result in
            switch result{
            case .failure(let error):
                DispatchQueue.main.async{
                    self.showAlert("Authentication Error", error.localizedDescription)
                }
            case .success(let authData):
                
                let newUser = EndUser(userId: authData.user.uid, timeCreated: Timestamp(date: Date()), email: self.userEmail, selectedExperience: self.selectedExperience.rawValue)
                FirestoreService.manager.createNewUser(newUser) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async{
                            self?.showAlert("Authentication Error", error.localizedDescription)
                        }
                    case .success:
                        self?.sceneChange()
                    }
                }
            }
        }
    }
    
    private func sceneChange(){
        let storyboard = UIStoryboard(name: "Events", bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: "EventsViewController") { [unowned self] coder in
            return EventsViewController(coder, self.selectedExperience)
        }
        let navigation = UINavigationController(rootViewController: newVC)
        UIViewController.showViewController(storyboardName: nil, viewControllerId: nil, viewController: navigation)
    }
}

extension SelectUserExperienceController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return experiences.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return experiences[row]
    }
}

extension SelectUserExperienceController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case 0:
            selectedExperience = UserExperience.ticketMaster
        case 1:
            selectedExperience = UserExperience.rijksMuseum
        default:
            break
        }
    }
}
