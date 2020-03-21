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
        firestoreRef.collection(CollectionName.usersCollection).document(user.userId).setData(user.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func getUserData(_ userId: String, completion: @escaping (Result<EndUser,Error>) -> ()){
        
        firestoreRef.collection(CollectionName.usersCollection).whereField(UserModelFields.userId, isEqualTo: userId).getDocuments { (snapshot, error) in
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
    
    public func updateUserExperience(_ userId: String, _ exp: UserExperience, completion: @escaping (Result<Bool,Error>) -> ()){
        firestoreRef.collection(CollectionName.usersCollection).document(userId).updateData([UserModelFields.selectedExperience: exp.rawValue]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func addFavourite(_ event: EventFavourite? = nil, _ artPiece: ArtFavourite? = nil, completion: @escaping (Result<Bool,Error>) -> ()){
        
        if let event = event {
            firestoreRef.collection(CollectionName.eventFavouritesCollection).document(event.eventId).setData(event.dictionary) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
            
        } else if let art = artPiece {
            firestoreRef.collection(CollectionName.artFavouritesCollection).document(art.objectNumber).setData(art.dictionary) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
            
        }
    }
    
    public func isInFavourites(_ id: String, _ typeOfFavourite: UserExperience, completion: @escaping (Result<Bool, Error>) -> ()){
        guard let user = Auth.auth().currentUser else { return }
        
        if typeOfFavourite == UserExperience.ticketMaster {
            firestoreRef.collection(CollectionName.eventFavouritesCollection).whereField(EventFavouriteFields.favouritedById, isEqualTo: user.uid).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot{
                    let docs = snapshot.documents.compactMap{EventFavourite(using:$0.data())}.filter{$0.eventId == id}
                    if docs.count > 0 {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            }
        } else if typeOfFavourite == UserExperience.rijksMuseum{
            firestoreRef.collection(CollectionName.artFavouritesCollection).whereField(ArtFavouriteFields.favouritedById, isEqualTo: user.uid).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    let docs = snapshot.documents.compactMap{EventFavourite(using:$0.data())}.filter{$0.eventId == id}
                    if docs.count > 0 {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            }
        }
    }
    
    public func removeFromFavourites(_ id: String, _ typeOfFavourite: UserExperience, completion: @escaping (Result<Bool,Error>) -> () ){
        
        if typeOfFavourite == UserExperience.ticketMaster{
            firestoreRef.collection(CollectionName.eventFavouritesCollection).document(id).delete { error in
                if let error = error {
                    completion(.failure(error))
                }else {
                    completion(.success(true))
                }
            }
        } else if typeOfFavourite == UserExperience.rijksMuseum{
            firestoreRef.collection(CollectionName.artFavouritesCollection).document(id).delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
}
