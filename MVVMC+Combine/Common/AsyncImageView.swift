//
//  AsyncImageView.swift
//  MVVMC+Combine
//
//  Created by Davit on 09.03.24.
//

import UIKit

protocol ImageLoaderRepository {
    func loadImage(from url: URL) async throws -> Data
}

class DefaultImageLoaderRepository: ImageLoaderRepository {
    func loadImage(from url: URL) async throws -> Data {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let (data, _) = try await session.data(from: url)
        return data
    }
}

class AsyncImageView: UIImageView {
    private let repository: ImageLoaderRepository
    private var task: Task<Void, Error>? { willSet { task?.cancel() } }

    init(repository: ImageLoaderRepository = DefaultImageLoaderRepository()) {
        self.repository = repository
        super.init(image: nil, highlightedImage: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(from url: String) {
        self.image = nil
        
        task?.cancel()
        
        guard let imageURL = URL(string: url) else { return }
        
        task = Task {
            do {
                let imageData = try await repository.loadImage(from: imageURL)
                
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.image = image
                }
                
            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
        
    }
}
