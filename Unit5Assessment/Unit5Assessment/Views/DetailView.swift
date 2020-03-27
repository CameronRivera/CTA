//
//  DetailView.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/23/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class DetailView: UIView {

    public lazy var imageView: UIImageView = {
       let iv = UIImageView()
        return iv
    }()
    
    public lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont(name: "Times New Roman", size: 30)
        return textView
    }()
    
    public lazy var favouriteButton: UIBarButtonItem = {
        let favouriteButton = UIBarButtonItem()
        return favouriteButton
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
        setUpImageViewConstraints()
        setUpTextViewConstraints()
    }
    
    private func setUpImageViewConstraints(){
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8), imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8), imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)])
    }
    
    private func setUpTextViewConstraints(){
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8), textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8), textView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8), textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)])
    }
}
