//
//  OrderScreen.swift
//  Yummie
//
//  Created by MacOS on 12/08/2022.
//

import UIKit
import ProgressHUD

class OrderScreen: UIViewController {
    
    //MARK: - IBOutlet
    
    let verticalStack   = UIStackView()
    let imageView       = UIImageView()
    let horizontalStack = UIStackView()
    let dishTitle       = YATitleLable(size: 20)
    let calories        = YATitleLable(size: 18)
    let dishDescription = YADescriptionLable()
    let nameField       = UITextField()
    let button          = YAButton(background: .darkGray)
    
    private var dish : Dish!
    
    init(dish : Dish) {
        super.init(nibName: nil, bundle: nil)
        configure()
        self.dish = dish
        self.set(dish: dish)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        view.backgroundColor = .systemGray
        
        verticalStack.axis = .vertical
        view.addSubview(verticalStack)
        verticalStack.setToEdges(containerView: view)
        verticalStack.spacing = 15
        verticalStack.backgroundColor = YAColors.background
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 25
        
        calories.text = "120 Calories"
        calories.textColor = .red
        
        horizontalStack.addArrangedSubview(dishTitle)
        horizontalStack.addArrangedSubview(calories)
        
        verticalStack.addArrangedSubview(imageView)
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(dishDescription)
        verticalStack.addArrangedSubview(nameField)
        verticalStack.addArrangedSubview(button)
        
        dishDescription.text = "a container, flatter than a bowl and sometimes with a lid, from which food can be served or which"
        
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.placeholder = "Enter your name"
        nameField.font = UIFont(name: "Avenir Next Regular", size: 20)
        nameField.backgroundColor = .systemBackground
        nameField.borderStyle = .roundedRect
        
        button.setTitle("Place Order", for: .normal)
        button.addTarget(self, action: #selector(orderAction),
                         for: .touchUpInside)
        
        let padding : CGFloat = 10
        
        NSLayoutConstraint.activate([
            
            button.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor,constant: padding),
            button.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor,constant: -padding),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            nameField.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor,constant: padding),
            nameField.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor,constant: -padding),
            nameField.heightAnchor.constraint(equalToConstant: 50),
            
            dishDescription.leadingAnchor.constraint(equalTo:verticalStack.leadingAnchor,constant: padding),
            dishDescription.trailingAnchor.constraint(equalTo:verticalStack.trailingAnchor,constant: -padding),
            
            imageView.widthAnchor.constraint(equalTo: verticalStack.widthAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 650)
            
        ])
    }
    
    private func set(dish : Dish){
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
        
        dishTitle.text          = dish.name ?? "NO Name"
        calories.text           = dish.formattedCalories
        dishDescription.text    = dish.description ?? "No Discription"
        imageView.tintColor = .red
    }
    
    //MARK: - Action
    
    @objc func orderAction(){
        guard nameField.text != "" else{
            ProgressHUD.showFailed("You must inter your name")
            return
        }
        ProgressHUD.show("Placing order ...")
        NetworkManager.shared.placeOrder(dishId: dish.id! , name: nameField.text!) { result in
            switch result{
            case .success(_):
                ProgressHUD.showSuccess("Order has been added Succeccfully")
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
            
        }
    }
    
    
}
