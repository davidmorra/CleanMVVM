//
//  CharacterDetailsViewController.swift
//  MVVMC+Combine
//
//  Created by Davit on 05.03.24.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section {
        case header, info, episodes
    }
    
    enum Item: Hashable {
        case headerItem
        case infoItem(UUID = UUID())
        case episodeItem(UUID = UUID())
    }
    
    var datasource: DataSource!
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        return collectionView
    }()
    
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
    }
    
    private func setupDataSource() {
        datasource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .headerItem:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailHeaderCell.reuseID, for: indexPath)
                return cell
            case .infoItem:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailInfoCell.reuseID, for: indexPath) as! CharacterDetailInfoCell
                cell.configure("Avoe", "Hehei")
                return cell
            case .episodeItem:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailEpisodeCell.reuseID, for: indexPath) as! CharacterDetailEpisodeCell
                cell.configure(with: "", subtitle: "")
                return cell
            }
        })
        
        var snapshot = Snapshot()
        snapshot.appendSections([.header, .info, .episodes])
        snapshot.appendItems([.headerItem], toSection: .header)
        snapshot.appendItems([.infoItem(), .infoItem()], toSection: .info)
        snapshot.appendItems([.episodeItem(), .episodeItem(), .episodeItem(), .episodeItem(), .episodeItem()], toSection: .episodes)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .estimated(58))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(58))
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
    let controller = CharacterDetailsViewController()
    return controller
}

