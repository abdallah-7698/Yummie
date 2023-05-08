

//
//  Route.swift
//  Yummie
//
//  Created by MacOS on 13/08/2022.
//
// ehat this file do is getting the URL only
import Foundation

enum Route {
    
    static let baseURL = "https://yummie.glitch.me"
    
    case feachAllCategories
    case placeOrder (String)
    case feachCategoryDishes(String)
    case feachOrders
    
    var description : String{
        switch self {
        case .feachAllCategories: return "/dish-categories"
        case .placeOrder(let dishId): return "/orders/\(dishId)"
        case .feachCategoryDishes(let categoryId): return "/dishes/\(categoryId)"
        case .feachOrders: return "/orders"
        }
    }
}
