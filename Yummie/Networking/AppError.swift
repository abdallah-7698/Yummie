//
//  AppError.swift
//  Yummie
//
//  Created by MacOS on 14/08/2022.
//

import Foundation

enum AppError : LocalizedError {
    case errorDecoding
    case unknownError
    case invalidURL
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .errorDecoding:
            return "Responce could not ba decoded"
        case .unknownError:
            return "Not expected error happen!"
        case .invalidURL:
            return "The URL is unvalid"
        case .serverError(let error):  // he give you the error
            return error
        }
    }
    
}
