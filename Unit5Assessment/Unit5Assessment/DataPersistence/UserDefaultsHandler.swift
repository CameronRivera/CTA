//
//  UserDefaultsHandler.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/17/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

struct UserDefaultsHandler {

    func setExperience(_ exp: UserExperience, _ userId: String) {
        UserDefaults.standard.set(exp.rawValue, forKey: userId)
    }

    func getUserExperience(using userId: String) -> UserExperience{
        guard let exp = UserDefaults.standard.object(forKey: userId) as? String else {
            return UserExperience.ticketMaster
        }
        return UserExperience(rawValue: exp) ?? UserExperience.ticketMaster
    }
}
