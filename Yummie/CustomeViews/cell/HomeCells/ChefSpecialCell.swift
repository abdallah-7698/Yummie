//
//  ChefSpecialCell.swift
//  Yummie
//
//  Created by MacOS on 07/08/2022.
//

import UIKit

class ChefSpecialCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    let view = UIView()
    let imageView = UIImageView()
    let title = YATitleLable(size: 25)
    let price = YATitleLable(size: 20)
    
    //MARK: - Constant
    
    static let reuseID = "ChefSpecialCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        contentView.addSubview(view)
        view.backgroundColor = YAColors.gray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setToEdges(containerView: contentView)
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBackground
        view.addSubviews(imageView , title , price)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        
        let padding : CGFloat = 10
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 15),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor , multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: view.heightAnchor , multiplier: 0.8),
            
            title.topAnchor.constraint(equalTo: view.topAnchor , constant: padding),
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor , constant: padding),
            
            price.topAnchor.constraint(equalTo: title.bottomAnchor , constant: padding),
            price.leadingAnchor.constraint(equalTo: imageView.trailingAnchor , constant: padding),
        ])
    }
    
    func set(dish : Dish){
        guard let imageName = dish.image else {
            imageView.image = UIImage(systemName: "Book")
            return
        }
        NetworkManager.shared.downloadImage(from: imageName, completion: {[weak self] image in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
        title.text = dish.name ?? "NO Name"
        price.text = "$\(Int.random(in: 5...99))"
    }
    
    func set(order : Order){
        guard let imageName = order.dish?.image else {
            imageView.image = UIImage(systemName: "Book")
            return
        }
        NetworkManager.shared.downloadImage(from: imageName, completion: {[weak self] image in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
        title.text = order.dish?.name ?? "NO Name"
        price.text = order.name
    }
    
    
}
