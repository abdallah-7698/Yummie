//
//  AllDishes.swift
//  Yummie
//
//  Created by MacOS on 25/08/2022.
//

import Foundation

struct AllDishes : Codable{
    let categories : [DishCategory]?
    let populars : [Dish]?
    let specials : [Dish]?
}
