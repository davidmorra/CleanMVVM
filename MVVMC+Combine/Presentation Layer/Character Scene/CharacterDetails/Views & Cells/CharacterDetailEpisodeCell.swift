//
//  CharacterDetailEpisodeCell.swift
//  MVVMC+Combine
//
//  Created by Davit on 07.03.24.
//

import UIKit

class CharacterDetailEpisodeCell: UICollectionViewCell {
    static var reuseID = "CharacterDetailEpisodeCell"
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let bottomLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        subtitleLabel.font = .preferredFont(forTextStyle: .footnote)
        subtitleLabel.textColor = .gray

        bottomLine.backgroundColor = .systemGray5

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(bottomLine)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            bottomLine.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            bottomLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func configure(with title: String, subtitle: String) {
        titleLabel.text = "Pilot"
        subtitleLabel.text = "S03E07"
    }
}

