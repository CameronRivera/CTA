//
//  FirestoreService.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirestoreService {
    public static let manager = FirestoreService()
    private let firestoreRef = Firestore.firestore()
    
    private init(){
        
    }
    
    public func createNewUser(_ user: EndUser, completion: @escaping (Result<Bool,Error>) -> ()){
        firestoreRef.collection(Constants.usersCollection).document(user.userId).setData(user.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func getUserData(_ userId: String, completion: @escaping (Result<EndUser,Error>) -> ()){
        
        firestoreRef.collection(Constants.usersCollection).whereField(UserModelFields.userId, isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let user = snapshot.documents.compactMap{ EndUser(using: $0.data())}
                if let firstUser = user.first {
                    completion(.success(firstUser))
                }
            }
        }
    }
}
