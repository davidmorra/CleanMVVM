//
//  CharacterDetailHeaderCell.swift
//  MVVMC+Combine
//
//  Created by Davit on 07.03.24.
//

import UIKit

class CharacterDetailHeaderCell: UICollectionViewCell {
    static let reuseID = "CharacterDetailHeaderCell"
    
    private let imageSize: CGFloat = 120
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [characterImageView, characterLabel, subtitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 12
        stack.setCustomSpacing(2, after: characterLabel)
        
        return stack
    }()
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = imageSize/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var characterLabel: UILabel = {
        let label = UILabel()
        label.text = "Morty"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Human - Alive"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    }()
    
    var imageLoaderTask: Task<Data, Error>? {
        willSet { imageLoaderTask?.cancel() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            characterImageView.heightAnchor.constraint(equalToConstant: imageSize),
            characterImageView.widthAnchor.constraint(equalToConstant: imageSize),
        ])

    }
    
    func fill(with viewmodel: CharacteresDetailsViewModel.Header) {
        characterImageView.image = nil
        
        characterLabel.text = viewmodel.name
        subtitleLabel.text = viewmodel.species + " - " + viewmodel.status
            
        guard let url = URL(string: viewmodel.imageURL) else { return }
        
        imageLoaderTask = Task { [weak self] in
            let (data, _) = try await URLSession.shared.data(from: url)
            self?.characterImageView.image = UIImage(data: data)
            
            self?.imageLoaderTask = nil
            
            return data
        }
    }
}
