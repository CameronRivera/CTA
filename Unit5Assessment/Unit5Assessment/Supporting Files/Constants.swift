//
//  Constants.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/15/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

enum AccountState{
    case existingUser
    case newUser
}

struct Constants {
    public static let usersCollection = "users"
}

struct UserModelFields {
    public static let userId = "userId"
    public static let timeCreated = "timeCreated"
    public static let email = "email"
    public static let selectedExperience = "selectedExperience"
}
