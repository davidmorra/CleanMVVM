//
//  CharactersViewModel.swift
//  MVVMC+Combine
//
//  Created by Davit on 26.02.24.
//

import Foundation
import Combine
import Domain
import Data_Layer

enum State<T> {
    case idle
    case loaded(T)
    case error(Error)
    case empty
}

final class CharactersViewModel {
    enum Event {
        case onAppear
        case onSelect(_ id: Int)
    }
    
    @Published var state = State<[CharacterItemViewModel]>.idle {
        didSet { isLoading = false }
    }
    
    @Published var isLoading = false
    
    private let currentPage = 0
    private var totalPage: Int?
    
    private let useCase: CharactersUseCaseProtocol
    
    init(useCase: CharactersUseCaseProtocol = CharactersUseCase(charactersRepository: CharactersRepositoryImpl())) {
        self.useCase = useCase
    }
    
    @MainActor
    private func loadCharacters() {
        isLoading = true
        
        Task {
            try await Task.sleep(for: .seconds(2))
            do {
                let characterResponse = try await useCase.fetchAllCharacters(with: .init(page: 0))
                
                guard !characterResponse.results.isEmpty else {
                    state = .empty
                    return
                }
                
                state = .loaded(characterResponse.results.map(CharacterItemViewModel.init))
            } catch {
                state = .error(error)
            }
        }

    }
    
    @MainActor 
    func handleEvent(_ event: Event) {
        switch event {
        case .onAppear:
            loadCharacters()
        case .onSelect(let id):
            ()
        }
    }
}
