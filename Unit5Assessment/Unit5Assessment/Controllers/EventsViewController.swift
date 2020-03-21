//
//  EventsViewController.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

class EventsViewController: UIViewController {
    // Note: to self, make specific errors for scope. What I mean is, remember to write a valid alert error when the user searches for an event using the wrong method in the wrong scope.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var userExp: UserExperience
    
    private var events = [Event](){
        didSet{
            if events.count > 0{
                DispatchQueue.main.async{
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async{
                    self.showAlert("No Matching Events", "No events matched your query. Try again with a different query.")
                }
            }
        }
    }
    
    private var artPieces = [ArtPiece](){
        didSet{
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        }
    }
    
    private var searchQuery = "" {
        didSet{
            processSearchQuery(searchQuery.lowercased())
        }
    }
    
    init?(_ coder: NSCoder, _ exp: UserExperience){
        userExp = exp
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if userExp == UserExperience.rijksMuseum{
            tableView.isHidden = true
            collectionView.isHidden = false
            setUpCollectionView()
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
            setUpTableView()
        }
    }
    
    private func setUp(){
        navigationItem.title = "Search Events"
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
    }
    
    private func setUpTableView(){
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Keyword","City","Postal Code"]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: CellsAndIdentifiers.ticketMasterReuseId)
        checkForEmptyState(events, .table)
        
    }
    
    private func setUpCollectionView(){
        searchBar.showsScopeBar = false
        searchBar.scopeButtonTitles = []
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: CellsAndIdentifiers.rijksMuseumXib, bundle: nil), forCellWithReuseIdentifier: CellsAndIdentifiers.rijksMuseumReuseId)
        checkForEmptyState(artPieces, .collection)
    }
    
    private func processSearchQuery(_ query: String){
        if userExp == .ticketMaster{
            processURLString(TicketMasterAPI.processSearchQuery(query, searchBar.selectedScopeButtonIndex))
        } else if userExp == .rijksMuseum {
            RijksMuseumAPI.getPieces(query) { [weak self] result in
                switch result{
                case .failure(let netError):
                    DispatchQueue.main.async{
                        self?.showAlert("Pieces Retrieval Error", "\(netError)")
                    }
                case .success(let pieces):
                    self?.artPieces = pieces
                }
            }
        }
    }
    
    private func processURLString(_ urlString: String){
        TicketMasterAPI.getEvents(urlString) { [weak self] result in
            switch result{
            case .failure(let netError):
                DispatchQueue.main.async{
                    self?.showAlert("Events Retrieval Error", "\(netError)")
                }
            case .success(let events):
                self?.events = events
            }
        }
    }
    
    private func checkForEmptyState<T>(_ arr: [T], _ view: TypeOfView){
        if view == .collection && arr.count < 1 {
            collectionView.backgroundView = EmptyStateView(title: "No Items", message: "There are no items that match your query. Use the search bar above to search for queries.")
        } else if view == .table && arr.count < 1 {
            tableView.separatorStyle = .none
            tableView.backgroundView = EmptyStateView(title: "No Items", message: "There are no items that match your query. Use the search bar above to search for queries.")
        }
    }
    
    private func addToFavourites(_ event: EventFavourite? = nil, _ eventCell: EventCell? = nil, _ artPiece: ArtFavourite? = nil, _ rijksCell: RijksCell? = nil){
        if let event = event, let eventCell = eventCell {
            FirestoreService.manager.addFavourite(event, nil) { [weak self] result in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async{
                        self?.showAlert("Favourite Error", error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async{
                        self?.showAlert("Event Added to Favourites", nil)
                        eventCell.favouriteButton.setBackgroundImage(UIImage(systemName: "moon.fill"), for: .normal)
                    }
                }
            }
        } else if let art = artPiece{
            
        }
    }
    
    @IBAction func favouritesButtonPressed(_ sender: UIBarButtonItem){
        let favouritesVC = FavouritesViewController(userExp)
        navigationController?.pushViewController(favouritesVC, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem){
        let settingsVC = SettingsViewController(userExp)
        settingsVC.delegate = self
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

extension EventsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let xCell = tableView.dequeueReusableCell(withIdentifier: CellsAndIdentifiers.ticketMasterReuseId, for: indexPath) as? EventCell else {
            fatalError("Could not dequeue cell as an EventCell.")
        }
        
        xCell.delegate = self
        xCell.configureCell(events[indexPath.row])
        return xCell
    }
}

extension EventsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension EventsViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artPieces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let xCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsAndIdentifiers.rijksMuseumReuseId, for: indexPath) as? RijksCell else {
            fatalError("Could not dequeue cell as a RijksCell.")
        }
        return xCell
    }
}

extension EventsViewController: UICollectionViewDelegateFlowLayout{
    
}

extension EventsViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let sbText = searchBar.text, !sbText.isEmpty else {
            showAlert("Invalid Search Query", nil)
            return
        }
        searchQuery = sbText
        searchBar.resignFirstResponder()
    }
    
}

extension EventsViewController: SettingsViewControllerDelegate{
    
    func userExperienceChanged(_ settingsViewController: SettingsViewController, _ newExp: UserExperience) {
        userExp = newExp
    }
    
}

extension EventsViewController: EventCellDelegate{

    func favouriteButtonPressed(_ eventCell: EventCell, currentEvent: Event) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let newFavourite = EventFavourite(eventId: currentEvent.id, imageURL: currentEvent.images.first?.url ?? "" , title: currentEvent.name, startDate: currentEvent.dates.start.localDate, favouritedById: user.uid)
        
        FirestoreService.manager.isInFavourites(currentEvent.id, UserExperience.ticketMaster) { [weak self]result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async{
                    self?.showAlert("Error", error.localizedDescription)
                }
            case .success(let exists):
                // Note: Consider putting this in another function
                if exists{
                    FirestoreService.manager.removeFromFavourites(currentEvent.id, UserExperience.ticketMaster) { [weak self] result in
                        switch result {
                        case .failure(let error):
                            DispatchQueue.main.async{
                                self?.showAlert("Removal Error", error.localizedDescription)
                            }
                        case .success(let removed):
                            if removed{
                                DispatchQueue.main.async{
                                    self?.showAlert("Unfavourited Event", nil)
                                    eventCell.favouriteButton.setBackgroundImage(UIImage(systemName: "moon"), for: .normal)
                                }
                            } 
                        }
                    }
                } else {
                    self?.addToFavourites(newFavourite, eventCell, nil, nil)
                }
            }
        }

    }
    
}
