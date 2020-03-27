//
//  DetailViewController.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/23/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    private let detailView = DetailView()
    private let currentEvent: EventFavourite?
    private let currentPiece: ArtFavourite?
    private let userExp: UserExperience
    private var isFavourite: Bool {
        didSet{
            self.updateTheMoon(isFavourite)
        }
    }
    
    init(_ currentEvent: EventFavourite? = nil, _ currentPiece: ArtFavourite? = nil, _ userExp: UserExperience, _ isFavourite: Bool){
        self.currentEvent = currentEvent
        self.currentPiece = currentPiece
        self.userExp = userExp
        self.isFavourite = isFavourite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(_ coder:) has not been implemented.")
    }
    
    override func loadView() {
        view = detailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        updateTheMoon(isFavourite)
        view.backgroundColor = UIColor.systemBackground
        detailView.favouriteButton.target = self
        detailView.favouriteButton.action = #selector(theMoonWasPressed)
        navigationItem.rightBarButtonItem = detailView.favouriteButton
        if let currentEvent = currentEvent{
            getDetailedInfo(currentEvent.eventId, userExp)
        } else if let currentPiece = currentPiece{
            getDetailedInfo(currentPiece.objectNumber, userExp)
        }
    }
    
    private func getDetailedInfo(_ id: String, _ experience: UserExperience){
        if experience == UserExperience.ticketMaster{
            TicketMasterAPI.getDetailedEventInfo(id) {[weak self] result in
                switch result {
                case .failure(let netError):
                    DispatchQueue.main.async{
                        self?.showAlert("Detailed Event Error", "\(netError)")
                    }
                case .success(let detail):
                    self?.setUpEvent(detail)
                }
            }
        } else if experience == UserExperience.rijksMuseum {
            RijksMuseumAPI.getDetailedPieces(id) { [weak self] result in
                switch result {
                case .failure(let netError):
                    DispatchQueue.main.async{
                        self?.showAlert("Detailed Art Piece Error", "\(netError)")
                    }
                case .success(let detail):
                    self?.setUpArtDetail(detail)
                }
            }
        }
    }
    
    private func setUpArtDetail(_ artDetail: DetailedArtPiece){
        DispatchQueue.main.async{
            self.navigationItem.title = artDetail.title
        }
        guard let piece = currentPiece else { return }
        detailView.imageView.getImage(artDetail.webImage?.url ?? piece.imageURL) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async{
                    self?.detailView.imageView.image = UIImage(systemName: "questionmark")
                }
            case .success(let image):
                DispatchQueue.main.async{
                    self?.detailView.imageView.image = image
                }
            }
        }
        DispatchQueue.main.async{
            self.detailView.textView.text = """
Title: \(artDetail.title)
        
Artist: \(artDetail.principalMakers.first?.name ?? "Artist Unknown")
        
Artist Date of Birth: \(artDetail.principalMakers.first?.dateOfBirth ?? "Unknown")
        
Artist Place of Birth: \(artDetail.principalMakers.first?.placeOfBirth ?? "Unknown")
        
Artist Date of Death: \(artDetail.principalMakers.first?.dateOfDeath ?? "Unknown")
        
Artist Place of Death: \(artDetail.principalMakers.first?.placeOfDeath ?? "Unknown")
        
Description: \(artDetail.plaqueDescriptionEnglish ?? "No description available")
"""
        }
    }
    
    private func setUpEvent(_ eventDetail: DetailedEvent){
        DispatchQueue.main.async{
            self.navigationItem.title = eventDetail.name
        }
        guard let event = currentEvent else { return }
        detailView.imageView.getImage(eventDetail.images.first?.url ?? event.imageURL) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async{
                    self?.detailView.imageView.image = UIImage(systemName: "questionmark")
                }
            case .success(let image):
                DispatchQueue.main.async{
                    self?.detailView.imageView.image = image
                }
            }
        }
        
        DispatchQueue.main.async{
            self.detailView.textView.text = """
Event Name: \(eventDetail.name)
            
Start Date: \(DateConverter.makeMyStringIntoAHumanDate(eventDetail.dates.start.localDate))
            
"""
            if let max = eventDetail.priceRanges?.first?.max, let min = eventDetail.priceRanges?.first?.min {
self.detailView.textView.text += """
                
Prices: Tickets start from $\(String(format: "%.2f", min)) and can be as expensive as $\(String(format: "%.2f", max))
                
"""
            } else {
self.detailView.textView.text += """
                
Prices: Price Information unavailable
                
"""
            }
            self.detailView.textView.text += """
            
Ticket Limit: \(eventDetail.ticketLimit?.info ?? "No information Available")
            
Accessibility: \(eventDetail.accessibility?.info ?? "No accessibility information available")
            
Promoter: \(eventDetail.promoter?.name ?? "Promoter Name Unavailable")
                        
Promoter Descrition: \(eventDetail.promoter?.description ?? "Promoter Description Unavailable")
"""
        }
    }
    
    @objc
    private func theMoonWasPressed(_ sender: UIBarButtonItem){
        if userExp == UserExperience.ticketMaster{
            guard let event = currentEvent else { return }
            if isFavourite{
                removeEventFromFavourites(event)
            } else {
                addEventToFavourites(event)
            }
        } else if userExp == UserExperience.rijksMuseum{
            guard let piece = currentPiece else { return }
            if isFavourite{
                removePieceFromFavourites(piece)
            } else {
                addPieceToFavourites(piece)
            }
        }
    }
    
    private func removeEventFromFavourites(_ event: EventFavourite){
        FirestoreService.manager.removeFromFavourites(event.eventId, UserExperience.ticketMaster) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async{
                    self?.showAlert("Removal Error", error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async{
                    self?.showAlert("Event Removed From Favourites", nil)
                    self?.isFavourite.toggle()
                    self?.updateTheMoon(self!.isFavourite)
                }
            }
        }
    }
    
    private func addEventToFavourites(_ event: EventFavourite){
        FirestoreService.manager.addFavourite(event, nil) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert("Favourite Event Error", error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async{
                    self?.showAlert("Event Added to Favourites", nil)
                    self?.isFavourite.toggle()
                    self?.updateTheMoon(self!.isFavourite)
                }
            }
        }
    }
    
    private func addPieceToFavourites(_ piece: ArtFavourite){
        FirestoreService.manager.addFavourite(nil, piece) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async{
                    self?.showAlert("Favourite Art Piece Error", error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async{
                    self?.showAlert("Added Piece to Favourites", nil)
                    self?.isFavourite.toggle()
                    self?.updateTheMoon(self!.isFavourite)
                }
            }
        }
    }
    
    private func removePieceFromFavourites(_ piece: ArtFavourite){
        FirestoreService.manager.removeFromFavourites(piece.objectNumber, UserExperience.rijksMuseum) { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async{
                    self?.showAlert("Removal Error", error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async{
                    self?.showAlert("Piece Removed From Favourites", nil)
                    self?.isFavourite.toggle()
                    self?.updateTheMoon(self!.isFavourite)
                }
            }
        }
    }
    
    private func updateTheMoon(_ status: Bool){
        if status{
            detailView.favouriteButton.image = UIImage(systemName: "moon.fill")
        } else {
            detailView.favouriteButton.image = UIImage(systemName: "moon")
        }
    }
}
