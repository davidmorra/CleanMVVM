//
//  ViewController.swift
//  MVVMC+Combine
//
//  Created by Davit on 04.02.24.
//

import UIKit
import Combine

public class CharactersViewController: UIViewController {
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CharacterItemViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CharacterItemViewModel>
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private lazy var footerActivityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private let viewmodel: CharactersViewModel
    private var datasource: DataSource!
    let publisher = CurrentValueSubject<Bool, Never>(false)

    init(viewmodel: CharactersViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Followers"
        setupCollectionView()
        setupDataSource()
        setupActivytyIndicator()
        
        viewmodel.handleEvent(.onAppear)
        
        viewmodel.$characters
            .sink(receiveValue: updateSnapshot(with:))
            .store(in: &cancellables)
        
        viewmodel.$isLoading
            .sink(receiveValue: isLoading(_:))
            .store(in: &cancellables)
        
        viewmodel.error
            .sink { error in
                print(">> ERROR: \(error)")
            }
            .store(in: &cancellables)
    }
    
    private func isLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
        
    private func setupActivytyIndicator() { 
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 44).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 44).isActive = true
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
        collectionView.register(CustomFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
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
        datasource = DataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, character in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
            cell.configure(with: character)
            
            if indexPath.row == self.viewmodel.characters.count - 1 {
                self.viewmodel.handleEvent(.onNextPage)
            }
            
            return cell
        })
        
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionFooter {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath) as! CustomFooterView
                footerView.bind(self.viewmodel.pagingationState, store: &self.cancellables)
                return footerView
            }
            return UICollectionReusableView()

        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    private func updateSnapshot(with characters: [CharacterItemViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters, toSection: .main)
        datasource.apply(snapshot)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1/2

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .estimated(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 16
        
        // Activity Indicator Footer
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

extension CharactersViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = datasource.snapshot().itemIdentifiers[indexPath.row].id
        viewmodel.handleEvent(.onSelect(id))
    }
}

class CustomFooterView: UICollectionReusableView {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomAnchor.constraint(equalTo: activityIndicator.bottomAnchor),
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ subject: CurrentValueSubject<PagingationState, Never>, store: inout Set<AnyCancellable>) {
        subject
            .receive(on: DispatchQueue.main)
            .sink { state in
                
                switch state {
                case .fullyLoaded:
                    ()
                case .nextPage:
                    ()
//                    isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
                case .initialLoading:
                    ()
                }
                
            }.store(in: &store)
    }
}
