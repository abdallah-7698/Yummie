//
//  Dish.swift
//  Yummie
//
//  Created by MacOS on 25/08/2022.
//

import Foundation

struct Dish: Codable{
    let id, name,description,image: String?
    let calories: Int?
    
    var formattedCalories : String {
        return "\(calories ?? 0) calories"
    }
    
}
