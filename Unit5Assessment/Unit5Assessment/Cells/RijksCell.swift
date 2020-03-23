//
//  RijksCell.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol RijksCellDelegate: AnyObject{
    func encounteredError(_ rijksCell: RijksCell, _ error: Error)
    func addedFavourite(_ rijksCell: RijksCell, _ message: String)
    func removedFavourite(_ rijksCell: RijksCell, _ message: String)
}

class RijksCell: UICollectionViewCell{
    
    @IBOutlet weak var artPieceImageView: UIImageView!
    @IBOutlet weak var artPieceTitleLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    private var artPiece: ArtPiece?
    private var artFavourite: ArtFavourite?
    private var imageURL = ""
    
    public weak var delegate: RijksCellDelegate?
    
    override func layoutSubviews() {
        favouriteButton.addTarget(self, action: #selector(theMoonWasPressed), for: .touchUpInside)
        favouriteButton.isUserInteractionEnabled = true
    }
    
    public func configureCell(_ artPiece: ArtPiece){
        self.artPiece = artPiece
        updateUI(artPiece.webImage?.url ?? "", artPiece.title, artPiece.objectNumber)
    }
    
    public func configureFavourite(_ fav: ArtFavourite){
        artFavourite = fav
        updateUI(fav.imageURL, fav.title, fav.objectNumber)
    }
    
    public func updateUI(_ imageURL: String, _ title: String, _ id: String){
        artPieceTitleLabel.text = title
        self.imageURL = imageURL
        artPieceImageView.getImage(imageURL) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async{
                    self?.artPieceImageView.image = UIImage(systemName: "questionmark")
                }
            case .success(let image):
                DispatchQueue.main.async{
                    if self?.imageURL == imageURL{
                        self?.artPieceImageView.image = image
                    }
                }
            }
        }
        
        FirestoreService.manager.isInFavourites(id, UserExperience.rijksMuseum) {[weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.encounteredError(self!, error)
            case .success(let exists):
                if exists{
                    DispatchQueue.main.async{
                        self?.favouriteButton.setBackgroundImage(UIImage(systemName: "moon.fill"), for: .normal)
                    }
                } else {
                    DispatchQueue.main.async{
                        self?.favouriteButton.setBackgroundImage(UIImage(systemName: "moon"), for: .normal)
                    }
                }
            }
        }
    }
    
    @objc
    private func theMoonWasPressed(){
        guard let user = Auth.auth().currentUser else { return }
        if let artPiece = artPiece{
            let newFavourite = ArtFavourite(objectNumber: artPiece.objectNumber, title: artPiece.title, maker: artPiece.principalOrFirstMaker, longTitle: artPiece.longTitle, imageURL: artPiece.webImage?.url ?? "", favouritedById: user.uid)
            areYouAFavourite(newFavourite)
        } else if let artFavourite = artFavourite{
            areYouAFavourite(artFavourite)
        }
    }
    
    private func areYouAFavourite(_ favourite: ArtFavourite){
        FirestoreService.manager.isInFavourites(favourite.objectNumber, UserExperience.rijksMuseum) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.encounteredError(self!, error)
            case .success(let exists):
                if exists{
                    self?.removeFromFavourites(favourite)
                } else {
                    self?.addToFavourites(favourite)
                }
            }
        }
    }
    
    private func addToFavourites(_ artFavourite: ArtFavourite){
        FirestoreService.manager.addFavourite(nil, artFavourite) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.encounteredError(self!, error)
            case .success:
                self?.delegate?.addedFavourite(self!, "Added Piece to Favourites")
                self?.favouriteButton.setBackgroundImage(UIImage(systemName: "moon.fill"), for: .normal)
            }
        }
    }
    
    private func removeFromFavourites(_ artFavourite: ArtFavourite){
        FirestoreService.manager.removeFromFavourites(artFavourite.objectNumber, UserExperience.rijksMuseum) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.encounteredError(self!, error)
            case .success:
                self?.delegate?.removedFavourite(self!, "Removed Piece from Favourites")
                self?.favouriteButton.setBackgroundImage(UIImage(systemName: "moon"), for: .normal)
            }
        }
    }
}
