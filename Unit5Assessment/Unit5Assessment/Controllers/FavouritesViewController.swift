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
            if eventFavourites.count > 0 {
                DispatchQueue.main.async{
                    self.favouritesView.tableView.backgroundView = nil
                    self.favouritesView.tableView.separatorStyle = .singleLine
                    self.favouritesView.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async{
                    self.checkForEmptyState(self.eventFavourites, UserExperience.ticketMaster)
                }
            }
        }
    }
    
    private var artFavourites = [ArtFavourite](){
        didSet{
            if artFavourites.count > 0{
                DispatchQueue.main.async{
                    self.favouritesView.collectionView.backgroundView = nil
                    self.favouritesView.collectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async{
                    self.checkForEmptyState(self.artFavourites, UserExperience.rijksMuseum)
                }
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
        checkForEmptyState(eventFavourites, UserExperience.ticketMaster)
    }
    
    private func setUpCollectionView(){
        favouritesView.tableView.alpha = 0.0
        favouritesView.collectionView.alpha = 1.0
        favouritesView.collectionView.dataSource = self
        favouritesView.collectionView.delegate = self
        favouritesView.collectionView.register(UINib(nibName: CellsAndIdentifiers.rijksMuseumXib, bundle: nil), forCellWithReuseIdentifier: CellsAndIdentifiers.rijksMuseumReuseId)
        checkForEmptyState(artFavourites, UserExperience.rijksMuseum)
    }
    
    private func checkForEmptyState<T>(_ arr: [T], _ userExp: UserExperience){
        
        if arr.count < 1 && userExp == UserExperience.rijksMuseum{
            favouritesView.collectionView.backgroundView = EmptyStateView(title: "No Favourites", message: "Navigate to the search screen to look for some pieces to add to your favourites.")
            favouritesView.collectionView.reloadData()
        } else if arr.count < 1 && userExp == UserExperience.ticketMaster{
            favouritesView.tableView.separatorStyle = .none
            favouritesView.tableView.backgroundView = EmptyStateView(title: "No Favourites", message: "Navigate to the search screen to look for some events to add to your favourites.")
            favouritesView.tableView.reloadData()
        }
    }
}

extension FavouritesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventFavourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let xCell = tableView.dequeueReusableCell(withIdentifier: CellsAndIdentifiers.ticketMasterReuseId, for: indexPath) as? EventCell else {
            fatalError("Could not dequeue cell as an EventCell")
        }
        
        xCell.configureFavourite(eventFavourites[indexPath.row])
        xCell.delegate = self
        return xCell
    }
}

extension FavouritesViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController(eventFavourites[indexPath.row], nil, userExp, true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavouritesViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artFavourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let xCell =  collectionView.dequeueReusableCell(withReuseIdentifier: CellsAndIdentifiers.rijksMuseumReuseId, for: indexPath) as? RijksCell else {
            fatalError("Could not dequeue cell as a RijksCell")
        }
        
        xCell.configureFavourite(artFavourites[indexPath.row])
        xCell.delegate = self
        xCell.layer.borderColor = UIColor.black.cgColor
        xCell.layer.borderWidth = 1.0
        return xCell
    }
}

extension FavouritesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width * 0.8, height: collectionView.bounds.size.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController(nil, artFavourites[indexPath.row], userExp, true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavouritesViewController: EventCellDelegate{
    
    func encounteredError(_ err: Error) {
        showAlert("Error", err.localizedDescription)
    }
    
    func addedToFavourites(_ message: String) {
        showAlert(message, nil)
    }
    
    func removedFromFavourites(_ message: String) {
        showAlert(message, nil)
    }
    
}

extension FavouritesViewController: RijksCellDelegate{
    
    func encounteredError(_ rijksCell: RijksCell, _ error: Error) {
        showAlert("Error", error.localizedDescription)
    }
    
    func addedFavourite(_ rijksCell: RijksCell, _ message: String) {
        showAlert(message, nil)
    }
    
    func removedFavourite(_ rijksCell: RijksCell, _ message: String) {
        showAlert(message, nil)
    }
    
}
