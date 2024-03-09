//
//  CharacterCell.swift
//  MVVMC+Combine
//
//  Created by Davit on 27.02.24.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    var imageLoaderTask: Task<Data, Error>? {
        willSet { imageLoaderTask?.cancel() }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewmodel: CharacterItemViewModel) {
        imageView.image = nil
        titleLabel.text = viewmodel.name
        subTitleLabel.text = viewmodel.species
        
        imageLoaderTask = Task(priority: .background) { [weak self] in
            guard let url = URL(string: viewmodel.imageUrl) else { throw URLError(.badURL) }
            let (data, _) = try await URLSession.shared.data(from: url)
                        
            self?.imageView.image = UIImage(data: data)
            self?.imageLoaderTask = nil
            return data
        }
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        let horizontalPadding: CGFloat = 12
        let verticalPadding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            subTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: verticalPadding),
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            
            titleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
                        
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 12)
        ])
    }
}
