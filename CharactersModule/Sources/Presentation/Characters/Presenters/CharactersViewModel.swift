//
//  CharactersViewModel.swift
//  MVVMC+Combine
//
//  Created by Davit on 26.02.24.
//

import Foundation
import Combine
import Domain
import Data

enum State<T> {
    case idle
    case loaded(T)
    case error(Error)
    case empty
}

enum PagingationState {
    case initialLoading
    case nextPage
    case fullyLoaded
}

final class CharactersViewModel {
    enum Event {
        case onAppear
        case onSelect(_ id: Int)
        case onNextPage
    }
    
    @Published var state = State<[CharacterItemViewModel]>.idle {
        didSet { isLoading = false }
    }
    
    @Published var isLoading = false
    private(set) var pagingationState = CurrentValueSubject<PagingationState, Never>(.initialLoading)
    
    private(set) var characters = [CharacterItemViewModel]()
    private var currentPage = 0
    private var totalPage = 1
    
    var nextPage: Int { hasMorePage ? currentPage + 1 : currentPage }
    var hasMorePage: Bool { currentPage < totalPage }
    var numberOfItems: Int { characters.count }
    
    private let useCase: CharactersUseCaseProtocol
    private var onSelect: ((Int) -> Void)?
    
    init(onSelect: @escaping ((Int) -> Void), useCase: CharactersUseCaseProtocol) {
        self.useCase = useCase
        self.onSelect = onSelect
    }
    
    @MainActor
    private func loadCharacters() {
        isLoading = true
        
        Task {
            do {
                let characterResponse = try await useCase.fetchAllCharacters(with: .init(page: nextPage))
                currentPage += 1
                
                guard !characterResponse.results.isEmpty else {
                    state = .empty
                    return
                }
                
                totalPage = characterResponse.info.pages
                characters.append(contentsOf: characterResponse.results.map(CharacterItemViewModel.init))
                state = .loaded(characters)
            } catch {
                state = .error(error)
            }
        }

    }
    
    @MainActor
    private func loadMoreCharacters() {
        guard hasMorePage else {
            pagingationState.send(.fullyLoaded)
            return
        }
        
        pagingationState.send(.nextPage)
        
        loadCharacters()
    }
    
    @MainActor 
    func handleEvent(_ event: Event) {
        switch event {
        case .onAppear:
            loadCharacters()
        case .onSelect(let id):
            onSelect?(id)
        case .onNextPage:
            loadMoreCharacters()
        }
    }
}
