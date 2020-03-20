//
//  DateConverter.swift
//  Unit5Assessment
//
//  Created by Cameron Rivera on 3/19/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

struct DateConverter{
    
    static func makeMyStringIntoAHumanDate(_ dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, YYYY"
        let date = dateFormatter.date(from: dateString) ?? Date()
        return dateFormatter.string(from: date)
    }
    
}
