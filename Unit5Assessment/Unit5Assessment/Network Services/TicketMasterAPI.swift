//
//  TicketMasterAPI.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

struct TicketMasterAPI {
    
    static func getEvents(_ urlString: String, completion: @escaping (Result<[Event],NetworkError>) -> ()) {
        
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
                    let events = try JSONDecoder().decode(EventTopLevel.self, from: data)
                    completion(.success(events.embedded.events))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }

    static func getDetailedEventInfo(_ eventId: String, completion: @escaping (Result<DetailedEvent,NetworkError>) -> ()){
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
                    let detailedEvent = try JSONDecoder().decode(DetailedEvent.self, from: data)
                    completion(.success(detailedEvent))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func processSearchQuery(_ query: String, _ index: Int) -> String{
        switch index{
        case 0:
            return  "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(APIKey.ticketMasterKey)&keyword=\(TicketMasterAPI.percentEncoding(query))"
        case 1:
            return "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(APIKey.ticketMasterKey)&City=\(TicketMasterAPI.percentEncoding(query))"
        case 2:
            return "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(APIKey.ticketMasterKey)&postalCode=\(TicketMasterAPI.percentEncoding(query))"
        default:
            return ""
        }
    }
    
    static func percentEncoding(_ string: String) -> String{
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
