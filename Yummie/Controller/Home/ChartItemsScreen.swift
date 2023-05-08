//
//  ChartItemsScreen.swift
//  Yummie
//
//  Created by MacOS on 13/08/2022.
//

import UIKit

class ChartItemsScreen: UIViewController {

    var collectionView : UICollectionView!
    
    private var dishesData : [DishModel] = []
    
    init(dishesData : [DishModel] ){
        super.init(nibName: nil, bundle: nil)
        self.dishesData = dishesData
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        view.backgroundColor = .systemBackground
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.register(ChefSpecialCell.self, forCellWithReuseIdentifier: ChefSpecialCell.reuseID)
    }

    private func createLayout()-> UICollectionViewCompositionalLayout{
        
        let item = NSCollectionLayoutItem.withIntireSize()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.13))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .padding(topBottom: 5, leftRight: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    
    
}

extension CategoryScreen : UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dishesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChefSpecialCell.reuseID,
                                                      for: indexPath) as! ChefSpecialCell
        cell.set(dish: dishesData[indexPath.row])
        cell.view.backgroundColor = YAColors.gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = OrderScreen(dish: dishesData[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
