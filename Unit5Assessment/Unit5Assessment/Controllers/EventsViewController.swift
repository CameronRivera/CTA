//
//  EventsViewController.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var userExp: UserExperience
    
    private var events = [Event](){
        didSet{
            DispatchQueue.main.async{
                self.tableView.reloadData()
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
        tableView.register(UINib(nibName: CellsAndIdentifiers.ticketMasterXib, bundle: nil), forCellReuseIdentifier: CellsAndIdentifiers.ticketMasterReuseId)
    }
    
    private func setUpCollectionView(){
        searchBar.showsScopeBar = false
        searchBar.scopeButtonTitles = []
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: CellsAndIdentifiers.rijksMuseumXib, bundle: nil), forCellWithReuseIdentifier: CellsAndIdentifiers.rijksMuseumReuseId)
        if artPieces.count < 1 {
            collectionView.backgroundView = EmptyStateView(title: "No Items", message: "There are no items that match your query. Use the search bar above to search for queries.")
        } else {
            collectionView.backgroundView = nil
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
        
        return xCell
    }
    
    private func processSearchQuery(_ query: String){
        if userExp == .ticketMaster{
            processURLString(TicketMasterAPI.processSearchQuery(query, searchBar.selectedScopeButtonIndex))
        } else if userExp == .rijksMuseum {
            RijksMuseumAPI.getPieces(query) { [weak self] result in
                switch result{
                case .failure(let netError):
                    DispatchQueue.main.async{
                        self?.showAlert("Pieces Retrieval Error", netError.localizedDescription)
                    }
                case .success(let pieces):
                    // Note: Get the pieces after you make a model
                    break
                }
            }
        }
    }
    
    private func processURLString(_ urlString: String){
        TicketMasterAPI.getEvents(urlString) { [weak self] result in
            switch result{
            case .failure(let netError):
                DispatchQueue.main.async{
                    self?.showAlert("Error Retrieving Events", netError.localizedDescription)
                }
            case .success(let events):
                // Note: Get the events after you have a model
                break
            }
        }
    }
}

extension EventsViewController: UITableViewDelegate{
    
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
