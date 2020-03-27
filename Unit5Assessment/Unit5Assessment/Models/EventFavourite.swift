//
//  Favourite.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/20/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

struct EventFavourite {
    
    let eventId: String
    let imageURL: String
    let title: String
    let startDate: String
    let favouritedById: String
    
    init(eventId: String, imageURL: String, title: String, startDate: String, favouritedById: String) {
        
        self.eventId = eventId
        self.imageURL = imageURL
        self.title = title
        self.startDate = startDate
        self.favouritedById = favouritedById
        
    }
    
    init?(using dictionary: [String:Any]){
        guard let eventId = dictionary[EventFavouriteFields.eventId] as? String,
            let imageURL = dictionary[EventFavouriteFields.imageURL] as? String,
            let title = dictionary[EventFavouriteFields.title] as? String,
            let startDate = dictionary[EventFavouriteFields.startDate] as? String,
            let favouritedById = dictionary[EventFavouriteFields.favouritedById] as? String else {
                return nil
        }
        
        self.eventId = eventId
        self.imageURL = imageURL
        self.title = title
        self.startDate = startDate
        self.favouritedById = favouritedById
        
    }
    
    var dictionary: [String:Any] {
        return [
            EventFavouriteFields.eventId : eventId,
            EventFavouriteFields.imageURL: imageURL,
            EventFavouriteFields.title : title,
            EventFavouriteFields.startDate : startDate,
            EventFavouriteFields.favouritedById : favouritedById
        ]
    }
}
