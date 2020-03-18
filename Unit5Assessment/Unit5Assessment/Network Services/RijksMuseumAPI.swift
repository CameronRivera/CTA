//
//  RijksMuseumAPI.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

struct RijksMuseumAPI {
    
    static func getPieces(_ query: String, completion: @escaping (Result<String,NetworkError>) -> ()){
        
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
                    //let pieces = try JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: data)
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func getDetailedPieces(_ objectNumber: String, completion: @escaping (Result<String,NetworkError>) -> ()){
        
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
                    //let detailedPieces = try JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: data)
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
