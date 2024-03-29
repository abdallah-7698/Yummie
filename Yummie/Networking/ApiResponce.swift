//
//  ApiResponce.swift
//  Yummie
//
//  Created by MacOS on 24/08/2022.
//

import Foundation

struct ApiResponse<T : Decodable> : Decodable{
    let status : Int
    let message : String?
    let data : T?
    let error : String?
}
