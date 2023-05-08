//
//  PopularDishesCell.swift
//  Yummie
//
//  Created by MacOS on 07/08/2022.
//

import UIKit

class PopularDishesCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    let view            = UIView()
    let imageView       = UIImageView()
    let title           = YATitleLable(size: 25)
    let subTitle        = YADescriptionLable()
    let stackView       = UIStackView()
    let prise           = YATitleLable()
    let orderButton     = YAOrderButton(title: "Order")
    
    //MARK: - Constant
    static let reuseID = "PopularDishesCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.clipsToBounds                              = true
        view.layer.cornerRadius                         = 20
        contentView.addSubview(view)
        view.setToEdges(containerView: contentView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.addArrangedSubview(prise)
        stackView.addArrangedSubview(orderButton)
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        view.addSubviews(imageView , title , subTitle , stackView)
        imageView.contentMode = .scaleToFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        
        let padding : CGFloat = 10
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor,constant: padding),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -padding),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor , multiplier: 0.5),
            
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor , constant: 5),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -padding),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor , constant: 5),
            subTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            subTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -padding),
            
            stackView.topAnchor.constraint(equalTo: subTitle.bottomAnchor , constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),

        ])
    }
    
    func set(dish :Dish , viewBackroundColor : UIColor , buttonBackgroundColor : UIColor){
        
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
        
        title.text          = dish.name ?? "NO Name"
        subTitle.text       = dish.formattedCalories
        prise.text          = "$\(Int.random(in: 5...99))"
        view.backgroundColor = viewBackroundColor
        orderButton.backgroundColor = buttonBackgroundColor
    }
    
    
}
