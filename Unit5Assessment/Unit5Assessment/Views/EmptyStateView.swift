//
//  EmptyStateView.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {

    public lazy var messageLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 4
        return label
    }()
    
    public lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        return label
    }()
    
    
    init(title: String, message: String) {
        super.init(frame: UIScreen.main.bounds)
        self.messageLabel.text = message
        self.titleLabel.text = title
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpMessageLabelConstraints()
        setUpTitleLabelConstraints()
    }
    
    private func setUpMessageLabelConstraints(){
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor), messageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), messageLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)])
    }

    private func setUpTitleLabelConstraints(){
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([titleLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8), titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)])
    }
}
