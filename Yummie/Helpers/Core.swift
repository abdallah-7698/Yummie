//
//  Core.swift
//  Yummie
//
//  Created by MacOS on 07/08/2022.
//

import Foundation

class Core{
    
    static let shared = Core()
    
    func isFirstTimeLogin()-> Bool{
        return UserDefaults.standard.bool(forKey: "isFirstTime")
    }
    
    func isNotFirstTime(){
        UserDefaults.standard.set(true, forKey: "isFirstTime")
    }
    
}
