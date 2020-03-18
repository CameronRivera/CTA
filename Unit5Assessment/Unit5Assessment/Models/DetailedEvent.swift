//
//  DetailedEvent.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct DetailedEvent: Decodable{
    let name: String
    let type: String
    let id: String
    let images: [Pic]
    let dates: EventDate
    let promoter: Promoter
    let priceRanges: [Price]
    let accessibility: Access
    let ticketLimit: Limit
}

struct EventDate: Decodable{
    let start: StartEventDate
}

struct StartEventDate: Decodable{
    let localDate: String // YYYY-MM-DD
    let localTime: String
    let dateTime: String // e.g. "2020-08-15T23:10:00Z"
}

struct Promoter: Decodable{
    let id: String
    let name: String
    let description: String
}

struct Price: Decodable{
    let type: String
    let currency: String
    let min: String
    let max: String
}

struct Access: Decodable{
    let info: String
}

struct Limit: Decodable{
    let info: String
}
