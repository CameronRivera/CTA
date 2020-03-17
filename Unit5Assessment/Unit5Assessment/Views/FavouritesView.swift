//
//  FavouritesView.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class FavouritesView: UIView {
    
    public lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = UIColor.systemBackground
        tv.alpha = 0.0
        return tv
    }()
    
    public lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.alpha = 0.0
        cv.backgroundColor = UIColor.systemBackground
        return cv
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
        setUpTableViewConstraints()
        setUpCollectionViewConstraints()
    }

    private func setUpTableViewConstraints(){
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor), tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func setUpCollectionViewConstraints(){
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor), collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }

}
