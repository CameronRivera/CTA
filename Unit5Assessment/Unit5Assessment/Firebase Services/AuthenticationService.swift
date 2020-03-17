//
//  AuthenticationService.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth

enum UserExperience: String{
    case ticketMaster = "TicketMaster"
    case rijksMuseum = "RijksMuseum"
}

class AuthenticationService{
    public static let manager = AuthenticationService()
    private let authRef = Auth.auth()
    
    private init(){
        
    }
    
    func signInExistingUser(_ email: String, _ password: String, completion: @escaping (Result<AuthDataResult,Error>) -> ()){
        authRef.signIn(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let dataResult = dataResult{
                // Note: DataResult contains a credential, could that be used with a phone log in to change phone numbers?
                completion(.success(dataResult))
            }
        }
    }
    
    func createNewAccount(_ email: String, _ password: String, completion: @escaping (Result<AuthDataResult,Error>) -> ()){
        authRef.createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let dataResult = dataResult{
                completion(.success(dataResult))
            }
        }
    }
}
