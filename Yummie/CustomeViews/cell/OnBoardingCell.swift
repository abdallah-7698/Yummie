//
//  OnBoardingCell.swift
//  Yummie
//
//  Created by MacOS on 06/08/2022.
//

import UIKit

class OnBoardingCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    let view        = UIView()
    let image       = UIImageView()
    let title       = YATitleLable()
    let descripe = YADescriptionLable()
    
    //MARK: - Constant
static let reuseID = "OnBoardingCell"
    
    override init(frame:CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ model: OnBoardingModel){
        image.image = model.image
        title.text = model.title
        descripe.text = model.description
    }
    
    private func configure(){
        contentView.addSubviews(view,image , title , descripe)
        view.setToEdges(containerView: contentView)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 20),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -20),
            image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            

            descripe.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15),
            descripe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descripe.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
            
        ])
        
    }
    
    
}
