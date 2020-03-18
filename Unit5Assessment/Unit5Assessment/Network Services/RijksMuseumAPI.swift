//
//  RijksMuseumAPI.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

struct RijksMuseumAPI {
    
    static func getPieces(_ query: String, completion: @escaping (Result<[ArtPiece],NetworkError>) -> ()){
        
        let urlString = "https://www.rijksmuseum.nl/api/en/collection?key=\(APIKey.rijksAPIKey)&q=\(RijksMuseumAPI.percentEncoding(query))"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(urlString)))
            return
        }
        
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(request) { result in
            switch result{
            case .failure(let netError):
                completion(.failure(.networkClientError(netError)))
            case .success(let data):
                do {
                    let pieces = try JSONDecoder().decode(ArtPieceWrapper.self, from: data)
                    completion(.success(pieces.artObjects))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func getDetailedPieces(_ objectNumber: String, completion: @escaping (Result<DetailedArtPiece,NetworkError>) -> ()){
        
        let urlString = "https://www.rijksmuseum.nl/api/en/collection/\(objectNumber)?key=\(APIKey.rijksAPIKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(urlString)))
            return
        }
        
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(request) { result in
            switch result {
            case .failure(let netError):
                completion(.failure(.networkClientError(netError)))
            case .success(let data):
                do {
                    let detailedPiece = try JSONDecoder().decode(DetailedArtPieceWrapper.self, from: data)
                    completion(.success(detailedPiece.artObject))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func percentEncoding(_ string: String) -> String{
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
