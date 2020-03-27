//
//  Event.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct EventTopLevel: Decodable{
    let embedded: EventWrapper
    
    enum CodingKeys: String, CodingKey{
        case embedded = "_embedded"
    }
}

struct EventWrapper: Decodable{
    let events: [Event]
}

struct Event: Decodable{
    let name: String
    let id: String
    let images: [Pic]
    let dates: EventDate
}

struct Pic: Decodable{
    let url: String
}
