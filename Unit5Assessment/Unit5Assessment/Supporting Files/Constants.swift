//
//  Constants.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/15/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

enum AccountState{
    case existingUser
    case newUser
}

struct CollectionName {
    public static let usersCollection = "users"
    public static let eventFavouritesCollection = "eventFavourites"
    public static let artFavouritesCollection = "artFavourites"
}

struct UserModelFields {
    public static let userId = "userId"
    public static let timeCreated = "timeCreated"
    public static let email = "email"
    public static let selectedExperience = "selectedExperience"
}

struct EventFavouriteFields {
    public static let eventId = "eventId"
    public static let imageURL = "imageURL"
    public static let title = "title"
    public static let startDate = "startDate"
    public static let favouritedById = "favouritedById"
}

struct ArtFavouriteFields {
    public static let objectNumber = "objectNumber"
    public static let title = "title"
    public static let maker = "maker"
    public static let longTitle = "longTitle"
    public static let imageURL = "imageURL"
    public static let favouritedById = "favouritedById"
}

struct CellsAndIdentifiers{
    public static let ticketMasterXib = "EventCell"
    public static let ticketMasterReuseId = "eventCell"
    public static let rijksMuseumXib = "RijksCell"
    public static let rijksMuseumReuseId = "rijksCell"
}
