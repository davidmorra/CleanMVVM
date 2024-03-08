//
//  CharacterDetailsViewController.swift
//  MVVMC+Combine
//
//  Created by Davit on 05.03.24.
//

import UIKit
import Combine

class CharacterDetailsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section {
        case header, info, episodes
    }
    
    enum Item: Hashable {
        case headerItem(CharacteresDetailsViewModel.Header)
        case infoItem(CharacteresDetailsViewModel.Info)
        case episodeItem(CharacteresDetailsViewModel.Episode)
    }
    
    private var datasource: DataSource!
    private lazy var snapshot = Snapshot()
    private var cancellables = Set<AnyCancellable>()
    private let viewmodel: CharacteresDetailsViewModel
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        return collectionView
    }()
    
    init(viewmodel: CharacteresDetailsViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray5
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        collectionView.register(CharacterDetailHeaderCell.self, forCellWithReuseIdentifier: CharacterDetailHeaderCell.reuseID)
        collectionView.register(CharacterDetailInfoCell.self, forCellWithReuseIdentifier: CharacterDetailInfoCell.reuseID)
        collectionView.register(CharacterDetailEpisodeCell.self, forCellWithReuseIdentifier: CharacterDetailEpisodeCell.reuseID)
        
        setupDataSource()
        viewmodel.fetchDetails()
        
        viewmodel.headerSection
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                self.updateHeaderSection(with: $0)
            }
            .store(in: &cancellables)
        
        viewmodel.infoSection
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                self.updateInfoSection(with: $0)
            }
            .store(in: &cancellables)
        
//        viewmodel.episodesSection
//            .receive(on: DispatchQueue.main)
//            .sink { [unowned self] in
//                self.updateEpisodeSection(with: $0)
//            }
//            .store(in: &cancellables)
    }
    
    private func setupDataSource() {
        datasource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .headerItem(let header):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailHeaderCell.reuseID, for: indexPath) as! CharacterDetailHeaderCell
                cell.fill(with: header)
                return cell
            case .infoItem(let info):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailInfoCell.reuseID, for: indexPath) as! CharacterDetailInfoCell
                cell.configure(info.name, iconName: info.iconName)
                return cell
            case .episodeItem(let episode):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailEpisodeCell.reuseID, for: indexPath) as! CharacterDetailEpisodeCell
                cell.configure(with: episode.name, subtitle: episode.episode)
                return cell
            }
        })
        
        snapshot.appendSections([.header, .info,])
    }
    
    private func updateHeaderSection(with header: CharacteresDetailsViewModel.Header) {
        let header = Item.headerItem(header)
        snapshot.appendItems([header], toSection: .header)
        datasource.apply(snapshot)
    }
    
    private func updateEpisodeSection(with episode: [CharacteresDetailsViewModel.Episode]) {
        let episode = episode.map(Item.episodeItem)
        snapshot.appendItems(episode, toSection: .episodes)
        datasource.apply(snapshot)
    }
    
    private func updateInfoSection(with info: [CharacteresDetailsViewModel.Info]) {
        let info = info.map(Item.infoItem)
        snapshot.appendItems(info, toSection: .info)
        datasource.apply(snapshot)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let fraction: CGFloat = 1

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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
            switch sectionIndex {
            case 0:
                return section
            case 1:
                return self.infoSectionLayout()
            default:
                return self.episodesSectionLayout()
            }
        }
        layout.register(RoundedBackgroundView.self, forDecorationViewOfKind: RoundedBackgroundView.reuseIdentifier)

        return layout
    }

    private func infoSectionLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1/2

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .estimated(88))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }
    
    private func episodesSectionLayout() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .estimated(56))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(56))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        section.interGroupSpacing = 4
        
        section.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: RoundedBackgroundView.reuseIdentifier)
        ]
        return section
    }

}

@available(iOS 17, *)
#Preview {
    let controller = CharacterDetailsViewController(viewmodel: .init(characterID: 0))
    return controller
}

