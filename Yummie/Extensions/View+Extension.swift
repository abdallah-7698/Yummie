//
//  View+Extension.swift
//  Yummie
//
//  Created by MacOS on 06/08/2022.
//

import UIKit

extension UIView{
    // it will add it to all views and will but it on the GUI attripute inspector
    //not needed we work in coding
    //    @IBInspectable var cornerRadius : CGFloat {
    //    get{return contentScaleFactor}
    //        set{
    //            self.layer.cornerRadius = newValue
    //        }
    //    }
    
    
    func addSubviews(_ views : UIView... ){
    views.forEach { addSubview($0)}
    }
    
    func setToEdges(containerView : UIView , top : CGFloat = 0 , leading : CGFloat = 0, trailing : CGFloat = 0 , bottom : CGFloat = 0){
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor , constant: top),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: leading),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor , constant: trailing),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor , constant: bottom)
        ])
    }
    
}
