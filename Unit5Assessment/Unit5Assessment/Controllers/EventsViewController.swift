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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var userExp: UserExperience
    
    private var events = [Event](){
        didSet{
            if events.count > 0{
                DispatchQueue.main.async{
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.backgroundView = nil
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
            if artPieces.count > 0{
                DispatchQueue.main.async{
                    self.collectionView.backgroundView = nil
                    self.collectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async{
                    self.showAlert("No Matching Pieces", "No art pieces matched your query. Try again with a different query.")
                }
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
            collectionView.reloadData()
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
            setUpTableView()
            tableView.reloadData()
        }
    }
    
    private func setUp(){
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
    }
    
    private func setUpTableView(){
        navigationItem.title = "Search Events"
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Keyword","City","Postal Code"]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: CellsAndIdentifiers.ticketMasterReuseId)
        checkForEmptyState(events, .table)
        
    }
    
    private func setUpCollectionView(){
        navigationItem.title = "Search Rijks Museum Pieces"
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
                case .failure:
                    DispatchQueue.main.async{
                    self?.showAlert("Invalid Search Query", "No art pieces matched your search query. Please try again using a different query.")
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
            case .failure:
                DispatchQueue.main.async{
                    self?.showAlert("Invalid Search Query", "No events matched your search query. Please try again using a different query.")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentCell = tableView.cellForRow(at: indexPath) as? EventCell, let user = Auth.auth().currentUser else {
            return
        }
        let currentEvent = events[indexPath.row]
        let eventFavourite = EventFavourite(eventId: currentEvent.id, imageURL: currentEvent.images.first?.url ?? "", title: currentEvent.name, startDate: currentEvent.dates.start.localDate, favouritedById: user.uid)
        let detailVC = DetailViewController(eventFavourite, nil, userExp, currentCell.getFavouriteStatus())
        navigationController?.pushViewController(detailVC, animated: true)
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
        xCell.configureCell(artPieces[indexPath.row])
        xCell.delegate = self
        xCell.layer.borderColor = UIColor.black.cgColor
        xCell.layer.borderWidth = 1.0
        return xCell
    }
}

extension EventsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width * 0.8, height: collectionView.bounds.size.height * 0.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentCell = collectionView.cellForItem(at: indexPath) as? RijksCell, let user = Auth.auth().currentUser else {
            return
        }
        
        let currentPiece = artPieces[indexPath.row]
        let currentFavourite = ArtFavourite(objectNumber: currentPiece.objectNumber, title: currentPiece.title, maker: currentPiece.principalOrFirstMaker, longTitle: currentPiece.longTitle, imageURL: currentPiece.webImage?.url ?? "", favouritedById: user.uid)
        
        let detailVC = DetailViewController(nil, currentFavourite, userExp, currentCell.getFavouriteStatus())
        navigationController?.pushViewController(detailVC, animated: true)
    }
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
        searchBar.text = ""
        if newExp == UserExperience.ticketMaster {
            artPieces = []
        } else if newExp == UserExperience.rijksMuseum {
            events = []
        }
    }
    
}

extension EventsViewController: EventCellDelegate{

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

extension EventsViewController: RijksCellDelegate{
    
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
