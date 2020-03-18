//
//  TicketMasterAPI.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

struct TicketMasterAPI {
    
    static func getEvents(_ urlString: String, completion: @escaping (Result<String,NetworkError>) -> ()) {
        
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
                    //let events = try JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: data)
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }

    static func getDetailedEventInfo(_ eventId: String, completion: @escaping (Result<String,NetworkError>) -> ()){
        let urlString = "https://app.ticketmaster.com/discovery/v2/events/\(eventId).json?apikey=\(APIKey.ticketMasterKey)"
        
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
                    //let detailedEvent = try JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: data)
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
