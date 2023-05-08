//
//  YAPageController.swift
//  Yummie
//
//  Created by MacOS on 06/08/2022.
//

import UIKit

class YAPageController: UIPageControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        currentPage = 0
        currentPageIndicatorTintColor = YAColors.red
        pageIndicatorTintColor = .systemGray5
        isUserInteractionEnabled = false
    }
    
}
