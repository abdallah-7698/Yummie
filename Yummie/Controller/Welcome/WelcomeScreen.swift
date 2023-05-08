//
//  WelcomeScreen.swift
//  Yummie
//
//  Created by MacOS on 07/08/2022.
//

import UIKit

class WelcomeScreen: UIViewController {

    
    let stackView = UIStackView()
    let image = UIImageView()
    let welcomeTitle = YATitleLable()
    let goToAppButton = YAButton(background: YAColors.black)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
    }
    
    private func configure(){
        view.backgroundColor = .systemBackground
        view.addSubviews(stackView , goToAppButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(welcomeTitle)
        stackView.spacing = 50
        stackView.axis = .vertical
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "appIcon")
        
        welcomeTitle.text = "Welcome"
        welcomeTitle.textColor = YAColors.red
        welcomeTitle.font = UIFont(name: "Marker Felt Thin", size: 37)
        
        goToAppButton.addTarget(self, action: #selector(goToOnBoarding), for: .touchUpInside)
        goToAppButton.setTitle("Start", for: .normal)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor , constant: -20),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.384487),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.618357),
            
            goToAppButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            goToAppButton.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 50),
            goToAppButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            goToAppButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.067)
         
        ])
    
    }

    @objc func goToOnBoarding(){
        let vc = OnBoardingScreen()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .partialCurl
        present(vc, animated: true)
    }
    
}
