//
//  OnBoardingScreen.swift
//  Yummie
//
//  Created by MacOS on 04/08/2022.
//

import UIKit

class OnBoardingScreen: UIViewController {
    
    //MARK: - IBOutlet
    
    var collectionView : UICollectionView!
    var pageIndex = YAPageController()
    var nextButton = YAButton(background: YAColors.black)
    
    //MARK: - Constant
    
    var currentIndex : Int = 0
    
    var onBoardingData : [OnBoardingModel] = [
        OnBoardingModel(title: "Delicious Dishes", description: "Experience a variety of amazing dishes from different cultures around the world.", image: #imageLiteral(resourceName: "slide2")) ,
        OnBoardingModel(title: "World-Class Chefs", description: "Our dishes are prepared by only the best.", image: #imageLiteral(resourceName: "slide1")),
        OnBoardingModel(title: "Instant World-Wide Delivery", description: "Your orders will be delivered instantly irrespective of your location around the world.", image: #imageLiteral(resourceName: "slide3"))
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Configure Funcs
    
    private func configure(){
        
        view.backgroundColor = .systemBackground
        setData()
        
        configureBageIndexAndButton()
        configureCollectionView()
    }
    
    private func configureBageIndexAndButton(){
        view.addSubviews(pageIndex , nextButton)
        
        nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        pageIndex.numberOfPages = onBoardingData.count
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.37), //150
            nextButton.heightAnchor.constraint(equalTo: view.heightAnchor , multiplier: 0.06), // 50
            
            pageIndex.bottomAnchor.constraint(equalTo: nextButton.topAnchor , constant: -15),
            pageIndex.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageIndex.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(OnBoardingCell.self, forCellWithReuseIdentifier: OnBoardingCell.reuseID)
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.setToEdges(containerView: view)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: pageIndex.topAnchor, constant: -20)
        ])
        
    }
    
    //MARK: - HelperFunctions
    // if avaliable ios 13 only so change it if not
    private func createLayout()-> UICollectionViewCompositionalLayout{
        
        let item = NSCollectionLayoutItem.withIntireSize()
        item.contentInsets = .padding(topBottom: 5, leftRight: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setData(){
        pageIndex.currentPage = currentIndex
        let text = currentIndex + 1 < onBoardingData.count ? "Next" : "GoTOApp"
        nextButton.setTitle(text, for: .normal)
    }
    
    @objc func buttonAction(){
        
        if currentIndex < onBoardingData.count - 1{
            currentIndex += 1
            collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }else{
            Core.shared.isNotFirstTime()
            let vc = UINavigationController(rootViewController: HomeScreen())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
    }
    
}

//MARK: - Extension


extension OnBoardingScreen:UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCell.reuseID, for: indexPath) as! OnBoardingCell
        cell.set(onBoardingData[indexPath.row])
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let indexOfVisableRows = collectionView.indexPathsForVisibleItems.map{ $0.row}[0]
        currentIndex = indexOfVisableRows
        setData()
        
    }
    
}
