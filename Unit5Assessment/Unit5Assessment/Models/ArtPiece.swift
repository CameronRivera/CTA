//
//  ArtPiece.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct ArtPieceWrapper: Decodable{
    let artObjects: [ArtPiece]
}

struct ArtPiece: Decodable{
    let links: Link
    let id: String
    let objectNumber: String
    let title: String
    let hasImage: Bool
    let principalOrFirstMaker: String
    let longTitle: String
    let webImage: WebPic
}

struct Link: Decodable{
    let `self`: String
    let web: String
}

struct WebPic: Decodable{
    let url: String
}
