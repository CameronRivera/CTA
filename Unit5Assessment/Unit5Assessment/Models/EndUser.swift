//
//  User.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/16/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import Firebase

struct EndUser{
    let userId: String
    let timeCreated: Timestamp
    let email: String
    let selectedExperience: String
    
    init(userId: String, timeCreated: Timestamp, email: String, selectedExperience: String){
        self.userId = userId
        self.timeCreated = timeCreated
        self.email = email
        self.selectedExperience = selectedExperience
    }
    
    init? (using dict: [String: Any]){
        guard let userId = dict[UserModelFields.userId] as? String,
            let timeCreated = dict[UserModelFields.timeCreated] as? Timestamp,
            let email = dict[UserModelFields.email] as? String,
            let selectedExperience = dict[UserModelFields.selectedExperience] as? String else {
                return nil
        }
        
        self.userId = userId
        self.timeCreated = timeCreated
        self.email = email
        self.selectedExperience = selectedExperience
    }
    
    var dictionary: [String : Any]{
        return [
            UserModelFields.userId: userId,
            UserModelFields.timeCreated: timeCreated,
            UserModelFields.email: email,
            UserModelFields.selectedExperience: selectedExperience
        ]
    }
}
