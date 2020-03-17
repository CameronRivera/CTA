//
//  NetworkError.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/15/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

enum NetworkError: Error{
    case noResponse
    case noData
    case badStatusCode(Int)
    case badURL(String)
    case decodingError(Error)
    case encodingError(Error)
    case networkClientError(Error)
}
