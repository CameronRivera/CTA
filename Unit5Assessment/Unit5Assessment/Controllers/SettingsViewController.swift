//
//  SettingsViewController.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol SettingsViewControllerDelegate: AnyObject {
    func userExperienceChanged(_ settingsViewController: SettingsViewController, _ newExp: UserExperience)
}

class SettingsViewController: UIViewController {

    private let settingsView = SettingsView()
    private let categories = ["TicketMaster", "RijksMuseum"]
    private var newState: UserExperience
    public weak var delegate: SettingsViewControllerDelegate?
    
    override func loadView() {
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitialValue()
    }
    
    init(_ state: UserExperience){
        newState = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(){
        settingsView.backgroundColor = .systemBackground
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = settingsView.signOutButton
        settingsView.signOutButton.target = self
        settingsView.signOutButton.action = #selector(signOutButtonPressed)
        settingsView.confirmButton.addTarget(self, action: #selector(confirmChangesButtonPressed), for: .touchUpInside)
        settingsView.pickerView.delegate = self
        settingsView.pickerView.dataSource = self
    }
    
    private func setInitialValue(){
        if newState == .ticketMaster{
            settingsView.pickerView.selectRow(0, inComponent: 0, animated: true)
        } else {
            settingsView.pickerView.selectRow(1, inComponent: 0, animated: true)
        }
    }
    
    @objc
    private func signOutButtonPressed(_ sender: UIBarButtonItem){
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            UIViewController.showViewController(storyboardName: nil, viewControllerId: nil, viewController: loginVC)
        } catch {
            showAlert("Sign Out Error",error.localizedDescription)
        }
    }
    
    @objc
    private func confirmChangesButtonPressed(_ sender: UIButton){
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        FirestoreService.manager.updateUserExperience(user.uid, newState) { [unowned self] result in
            switch result{
            case .failure(let error):
                DispatchQueue.main.async{
                    self.showAlert("Update Error", error.localizedDescription)
                }
            case .success:
                UserDefaultsHandler().setExperience(self.newState, user.uid)
                self.delegate?.userExperienceChanged(self, self.newState)
                self.showAlert("Changes Saved", nil) { [weak self] alertAction in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension SettingsViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}

extension SettingsViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            newState = UserExperience.ticketMaster
        case 1:
            newState = UserExperience.rijksMuseum
        default:
            break
        }
    }
}
