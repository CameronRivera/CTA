//
//  SettingsView.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    public lazy var signOutButton: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.title = "Sign Out"
        return button
    }()
    
    public lazy var directionsLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "Change user experience below"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    public lazy var pickerView: UIPickerView = {
       let pickerView = UIPickerView()
        return pickerView
    }()
    
    public lazy var confirmButton: UIButton = {
       let button = UIButton()
        button.setTitle("Confirm Changes", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpDirectionsLabelConstraints()
        setUpPickerViewConstraints()
        setUpConfirmButtonConstraints()
    }

    private func setUpDirectionsLabelConstraints(){
        addSubview(directionsLabel)
        directionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([directionsLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50), directionsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), directionsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)])
    }
    
    private func setUpPickerViewConstraints(){
        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([pickerView.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 20), pickerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), pickerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)])
    }
    
    private func setUpConfirmButtonConstraints(){
        addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([confirmButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 20), confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor), confirmButton.heightAnchor.constraint(equalToConstant: 44)])
    }
    
}
