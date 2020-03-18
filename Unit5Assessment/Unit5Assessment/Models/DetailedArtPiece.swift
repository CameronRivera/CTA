//
//  DetailedArtPiece.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct DetailedArtPieceWrapper: Decodable {
    let artObject: DetailedArtPiece
}

struct DetailedArtPiece: Decodable{
    let id: String
    let objectNumber: String
    let title: String
    let webImage: WebPic?
    let principalMakers: [Maker]
    let plaqueDescriptionDutch: String?
    let plaqueDescriptionEnglish: String?
}

struct Maker: Codable{
    let name: String
    let placeOfBirth: String?
    let dateOfBirth: String?
    let dateOfDeath: String?
    let placeOfDeath: String?
    let occupation: [String]
    let roles: [String]
    let nationality: String
}
