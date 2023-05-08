//
//  appViewController.swift
//  Yummie
//
//  Created by MacOS on 07/08/2022.
//

import UIKit
import ProgressHUD

class HomeScreen: UIViewController {
    
    //MARK: - IBOutlet
    var collectionView : UICollectionView!
    var topBarButton : UIButton!
    
    
    //MARK: - Constant
    
    var categories : [DishCategory] = []
    var popular : [Dish] = []
    var specials : [Dish] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getAllCategoriesData()
    }
    
    
    //MARK: - configure func
    private func configure(){
        view.backgroundColor = .systemBackground
        configureNavigation()
        configureCollectionView()
    }
    
    //MARK: - Configure Funcs
    
    
    private func configureNavigation(){
        
        title = "Yummie"
        topBarButton  = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "cart.circle.fill" , withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))), for: .normal)
            button.tintColor = .red
            button.addTarget(self, action: #selector(goToChart), for: .touchUpInside)
            return button
        }()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: topBarButton)
    }
    
    
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout())
        collectionView.backgroundColor = YAColors.background
        registerCells()
        collectionView.dataSource = self
        // for selection
        collectionView.delegate = self
        // collectionView.allowsMultipleSelection = true;
        view.addSubviews(collectionView)
    }
    
    private func registerCells(){
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
        collectionView.register(PopularDishesCell.self, forCellWithReuseIdentifier: PopularDishesCell.reuseID)
        collectionView.register(ChefSpecialCell.self, forCellWithReuseIdentifier: ChefSpecialCell.reuseID)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: "header",
                                withReuseIdentifier: HeaderView.reuseID)
    }
    
    //MARK: - HelperFunctions
    
    private func compositionalLayout()->UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout { index, environment in
            return self.createSectionFor(index: index, environment: environment)
        }
        return layout
    }
    
    private func createSectionFor(index : Int , environment : NSCollectionLayoutEnvironment)->NSCollectionLayoutSection {
        switch index{
        case 0:
            return createFirstSection()
        case 1:
            return createScecondSection()
        case 2:
            return createThirdSection()
        default:
            return createFirstSection()
        }
    }
    
    private func createFirstSection()->NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(10), top: .none, trailing: .none, bottom: .none)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                               heightDimension: .fractionalHeight(0.06))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createScecondSection()->NSCollectionLayoutSection{
        
        let item = NSCollectionLayoutItem.withIntireSize()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.36))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .padding(topBottom: 5, leftRight: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createThirdSection()->NSCollectionLayoutSection{
        
        let item = NSCollectionLayoutItem.withIntireSize()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.13))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .padding(topBottom: 5, leftRight: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    
    //MARK: - Get API data
    
    private func getAllCategoriesData(){
        ProgressHUD.show()
        NetworkManager.shared.featchAllCategories {[weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let allDishes):
                ProgressHUD.dismiss()
                self.categories = allDishes.categories ?? []
                self.popular    = allDishes.populars ?? []
                self.specials   = allDishes.specials ?? []
                self.collectionView.reloadData()
            case .failure(let error):
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Action Funcs
    @objc func goToChart(){
        let vc = CategoryScreen(type: .order, categoryId: nil,pageTitle: "Orders")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: - extensions

extension HomeScreen : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getNumberOfItemsIn(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        getCellAt(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: HeaderView.reuseID, for: indexPath) as? HeaderView else{return UICollectionReusableView()}
        view.title.text = headerTitle(section: indexPath.section)
        return view
    }
    
    //MARK: - Collection View func
    
    
    private func getCellAt(_ indexPath : IndexPath) -> UICollectionViewCell{
        
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID,
                                                          for: indexPath) as! CategoryCell
            cell.set(categort: categories[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularDishesCell.reuseID,
                                                          for: indexPath) as! PopularDishesCell
            let viewColor : UIColor   = indexPath.row % 2 == 0 ? YAColors.red : UIColor.white
            let buttonColor : UIColor = indexPath.row % 2 == 0 ? YAColors.alphaWhite : YAColors.red
            
            cell.set(dish: popular[indexPath.row],
                     viewBackroundColor: viewColor,
                     buttonBackgroundColor: buttonColor)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChefSpecialCell.reuseID,
                                                          for: indexPath) as! ChefSpecialCell
            cell.set(dish: specials[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChefSpecialCell.reuseID,
                                                          for: indexPath) as! ChefSpecialCell
            
            return cell
        }
        
    }
    
    private func getNumberOfItemsIn(section : Int)-> Int{
        switch section{
        case 0:
            return categories.count
        case 1:
            return popular.count
        case 2:
            return specials.count
        default:
            return 0
        }
    }
    
    private func headerTitle(section : Int)-> String{
        switch section{
        case 0:
            return "Food Category"
        case 1:
            return "Popular Dishes"
        case 2:
            return "Shef's Specials"
        default:
            return "No Title"
        }
    }
    
    private func selectCell(indexPath : IndexPath){
        switch indexPath.section{
        case 0 :
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            cell.isSelected = true
            cell.selection()
            let vc = CategoryScreen(type: .category, categoryId: categories[indexPath.row].id!,
                                    pageTitle: categories[indexPath.row].title!)
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            break
        case 2:
            let vc = OrderScreen(dish: specials[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
