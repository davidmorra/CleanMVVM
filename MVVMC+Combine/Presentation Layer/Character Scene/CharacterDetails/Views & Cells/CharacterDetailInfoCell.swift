//
//  CharacterDetailInfoCell.swift
//  MVVMC+Combine
//
//  Created by Davit on 07.03.24.
//

import UIKit

class CharacterDetailInfoCell: UICollectionViewCell {
    static let reuseID = "CharacterDetailInfoCell"
    
    private let iconSize: CGFloat = 28
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        return stack
    }()
    
    private lazy var iconImageView: UIImageView = {
        let icon = UIImage(systemName: "globe.americas.fill")
        let imageView = UIImageView(image: icon)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.text = "See all"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            vStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 12),
        ])
    }
    
    func configure(_ title: String, iconName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconName)
    }
}
