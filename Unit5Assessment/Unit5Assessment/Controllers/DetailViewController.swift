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
//
//    private var detailedEvent: DetailedEvent?{
//        didSet{
//
//        }
//    }
//
//    private var detailedPiece: DetailedArtPiece?{
//        didSet{
//
//        }
//    }
    
    
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
        detailView.imageView.getImage(artDetail.webImage?.url ?? "") { [weak self] result in
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
        
    }
    
    @objc
    private func theMoonWasPressed(_ sender: UIBarButtonItem){
        
    }
    
    private func updateTheMoon(_ status: Bool){
        if status{
            detailView.favouriteButton.image = UIImage(systemName: "moon.fill")
        } else {
            detailView.favouriteButton.image = UIImage(systemName: "moon")
        }
    }
}
