//
//  ViewController.swift
//  MVVMC+Combine
//
//  Created by Davit on 04.02.24.
//

import UIKit
import Combine

class CharactersViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CharactersViewController.layout())
        return collectionView
    }()
    
    let viewmodel: CharactersViewModel
    
    init(viewmodel: CharactersViewModel = CharactersViewModel()) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Followers"
        
        Task {
            try await viewmodel.loadCharacters()
        }
        
        viewmodel.$charactersArray.sink { characters in
            print(characters)
        }
        .store(in: &cancellables)
        
        setupSearchBar()
        setupCollectionView()
//        setupDataSource()
    }
    
    private func setupCollectionView() {
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }

    private func setupDataSource() {
    }
    
    private func setupSnapshot() {
    }
    
    private static func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(76))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
