//
//  categorySectionCell.swift
//  Yummie
//
//  Created by MacOS on 07/08/2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    
    let view            = UIView()
    let imageView       = UIImageView()
    let categoryName    = YAHeaderLable(size: 20)
    
    //MARK: - Constant
    static let reuseID : String = "CategoryCell"
    //MARK: - init
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - configure func
    
    private func configure(){
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .blue.withAlphaComponent(0.1)
        view.layer.cornerRadius = contentView.bounds.height / 2
        contentView.addSubview(view)
        view.setToEdges(containerView: contentView)
        view.addSubview(imageView)
        view.addSubview(categoryName)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = .systemGreen
        
        categoryName.textColor = .label
        categoryName.textAlignment = .center
        
        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 10),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor , multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: view.heightAnchor , multiplier: 0.7),
            
            categoryName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            categoryName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor , constant: 10),
            categoryName.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -20)
        ])
    }
    
    //MARK: - select and deselect the cell
    
    
    func selection(){
        if isSelected{
            categoryName.textColor = YAColors.red
            view.backgroundColor = .white
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.isSelected = false
                self.selection()
            }
        }else{
            categoryName.textColor = .label
            view.backgroundColor = .blue.withAlphaComponent(0.1)
        }
    }
    
    //MARK: - HelperFunctions
    
    func set(categort : DishCategory){
        guard let imageName = categort.image else {
            imageView.image = UIImage(systemName: "Book")
            return
        }
        NetworkManager.shared.downloadImage(from: imageName, completion: {[weak self] image in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
        categoryName.text = categort.title ?? "No name"
    }
    
}
