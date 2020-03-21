//
//  FavouritesViewController.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FavouritesViewController: UIViewController {
    
    private let favouritesView = FavouritesView()
    private let userExp: UserExperience
    private var listener: ListenerRegistration?
    private var eventFavourites = [EventFavourite](){
        didSet{
            DispatchQueue.main.async{
                self.favouritesView.tableView.reloadData()
            }
        }
    }
    
    private var artFavourites = [ArtFavourite](){
        didSet{
            DispatchQueue.main.async{
                self.favouritesView.collectionView.reloadData()
            }
        }
    }
    
    init(_ userExp: UserExperience){
        self.userExp = userExp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = favouritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = Auth.auth().currentUser else { return }
        if userExp == .ticketMaster {
            listener = Firestore.firestore().collection(CollectionName.eventFavouritesCollection).addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    DispatchQueue.main.async{
                        self?.showAlert("Listener Error", error.localizedDescription)
                    }
                } else if let snapshot = snapshot {
                    let eventFavs = snapshot.documents.compactMap{EventFavourite(using:$0.data())}.filter{$0.favouritedById == user.uid}
                    self?.eventFavourites = eventFavs
                }
            })
        } else if userExp == .rijksMuseum {
            listener = Firestore.firestore().collection(CollectionName.artFavouritesCollection).addSnapshotListener({ [weak self] (snapshot, error) in
                if let error = error {
                    DispatchQueue.main.async{
                        self?.showAlert("Listener Error", error.localizedDescription)
                    }
                } else if let snapshot = snapshot{
                    let artFavourites = snapshot.documents.compactMap{ArtFavourite(using:$0.data())}.filter{$0.favouritedById == user.uid}
                    self?.artFavourites = artFavourites
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    private func setUp(){
        view.backgroundColor = UIColor.systemBackground
        
        if userExp == .rijksMuseum{
            navigationItem.title = "Favourites: \(userExp.rawValue)"
            setUpCollectionView()
        } else if userExp == .ticketMaster{
            navigationItem.title = "Favourites: \(userExp.rawValue)"
            setUpTableView()
        }
    }
    
    private func setUpTableView(){
        favouritesView.collectionView.alpha = 0.0
        favouritesView.tableView.alpha = 1.0
        favouritesView.tableView.dataSource = self
        favouritesView.tableView.delegate = self
        favouritesView.tableView.register(EventCell.self, forCellReuseIdentifier: CellsAndIdentifiers.ticketMasterReuseId)
    }
    
    private func setUpCollectionView(){
        favouritesView.tableView.alpha = 0.0
        favouritesView.collectionView.alpha = 1.0
        favouritesView.collectionView.dataSource = self
        favouritesView.collectionView.delegate = self
        favouritesView.collectionView.register(UINib(nibName: CellsAndIdentifiers.rijksMuseumXib, bundle: nil), forCellWithReuseIdentifier: CellsAndIdentifiers.rijksMuseumReuseId)
        checkForEmptyState()
    }
    
    private func checkForEmptyState(){
        
        if eventFavourites.count > 0 {
            favouritesView.collectionView.backgroundView = nil
        } else {
            favouritesView.collectionView.backgroundView = EmptyStateView(title: "No Favourites", message: "Try searching for some art pieces in the search screen.")
        }
    }
    
}

extension FavouritesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let xCell = tableView.dequeueReusableCell(withIdentifier: CellsAndIdentifiers.ticketMasterReuseId, for: indexPath) as? EventCell else {
            fatalError("Could not dequeue cell as an EventCell")
        }
        
        xCell.configureFavourite(eventFavourites[indexPath.row])
        return xCell
    }
}

extension FavouritesViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

extension FavouritesViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventFavourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let xCell =  collectionView.dequeueReusableCell(withReuseIdentifier: CellsAndIdentifiers.rijksMuseumReuseId, for: indexPath) as? RijksCell else {
            fatalError("Could not dequeue cell as a RijksCell")
        }
        
        //xCell.configureCell()
        return xCell
    }
}

extension FavouritesViewController: UICollectionViewDelegateFlowLayout{
    
}
