//
//  CategoryScreen.swift
//  Yummie
//
//  Created by MacOS on 12/08/2022.
/// inheret from page but change the init

import UIKit
import ProgressHUD

enum PageType {
    case order
    case category
}

class CategoryScreen: UIViewController {
    
    var collectionView : UICollectionView!
    
    private var dishesData : [Dish] = []
    private var orders : [Order] = []
    private var pageType : PageType!
    private var pageTitle : String!
    
    
    
    init(type : PageType,categoryId : String?,pageTitle : String){
        super.init(nibName: nil, bundle: nil)
        self.pageType = type
        self.pageTitle = pageTitle
        configure()
        switch type {
        case .order:
            getOrders()
        case .category:
            getCategoryDish(categoryId: categoryId ?? "")
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        title = pageTitle
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
    
    private func getCategoryDish(categoryId : String){
        ProgressHUD.show()
        NetworkManager.shared.feachCategoryDishs(categoryId: categoryId) { [weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let dishes):
                ProgressHUD.dismiss()
                self.dishesData = dishes
                self.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
    private func getOrders(){
        ProgressHUD.show()
        NetworkManager.shared.feachOrders { [weak self] result in
            guard let self = self else{return}
            switch result{
            case .success(let orders):
                ProgressHUD.dismiss()
                self.orders = orders
                self.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
}

extension CategoryScreen : UICollectionViewDataSource , UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.isEmpty ?  dishesData.count :  orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChefSpecialCell.reuseID,
                                                      for: indexPath) as! ChefSpecialCell
        orders.isEmpty ? cell.set(dish: dishesData[indexPath.row]) : cell.set(order: orders[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if orders.isEmpty{
            let vc = OrderScreen(dish: dishesData[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }  
}
