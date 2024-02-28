//
//  ViewController.swift
//  MVVMC+Combine
//
//  Created by Davit on 04.02.24.
//

import UIKit
import Combine

class CharactersViewController: UIViewController {
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CharacterItemViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CharacterItemViewModel>
    
    var cancellables = Set<AnyCancellable>()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let viewmodel: CharactersViewModel
    var datasource: DataSource!
    
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
        setupCollectionView()
        setupDataSource()
        
        Task {
            try await viewmodel.loadCharacters()
        }
        
        viewmodel.$charactersArray
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        setupSearchBar()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "CharacterCell")
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
        datasource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, character in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
            cell.configure(with: character)
            return cell
        })
    }
    
    private func updateSnapshot(with characters: [CharacterItemViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters, toSection: .main)
        datasource.apply(snapshot)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1 / 2
        let inset: CGFloat = 4

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}
