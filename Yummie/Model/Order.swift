//
//  Order.swift
//  Yummie
//
//  Created by MacOS on 26/08/2022.
//

import Foundation

struct Order: Codable {
    let id: String?
    let name: String?
    let dish: Dish?
}
