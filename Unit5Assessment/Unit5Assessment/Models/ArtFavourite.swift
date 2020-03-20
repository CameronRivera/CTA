//
//  ArtFavourite.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/20/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

struct ArtFavourite{
    
    let objectNumber: String
    let title: String
    let maker: String
    let longTitle: String
    let imageURL: String
    let favouritedById: String
    
    init(objectNumber: String, title: String, maker: String, longTitle: String, imageURL: String, favouritedById: String){
        
        self.objectNumber = objectNumber
        self.title = title
        self.maker = maker
        self.longTitle = longTitle
        self.imageURL = imageURL
        self.favouritedById = favouritedById
        
    }
    
    init? (using dictionary: [String:Any]){
        guard let objectNumber = dictionary[ArtFavouriteFields.objectNumber] as? String,
            let title = dictionary[ArtFavouriteFields.title] as? String,
            let maker = dictionary[ArtFavouriteFields.maker] as? String,
            let longTitle = dictionary[ArtFavouriteFields.longTitle] as? String,
            let imageURL = dictionary[ArtFavouriteFields.imageURL] as? String,
            let favouritedById = dictionary[ArtFavouriteFields.favouritedById] as? String else {
                return nil
        }
        
        self.objectNumber = objectNumber
        self.title = title
        self.maker = maker
        self.longTitle = longTitle
        self.imageURL = imageURL
        self.favouritedById = favouritedById
        
    }
    
    var dictionary: [String : Any] {
        return [
            ArtFavouriteFields.objectNumber: objectNumber,
            ArtFavouriteFields.title: title,
            ArtFavouriteFields.maker: maker,
            ArtFavouriteFields.longTitle: longTitle,
            ArtFavouriteFields.imageURL: imageURL,
            ArtFavouriteFields.favouritedById: favouritedById
        ]
    }
}
