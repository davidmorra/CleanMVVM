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
    
    @Published var isLoading = false
    @Published private(set) var characters = [CharacterItemViewModel]()
    private(set) var error = PassthroughSubject<String, Never>()
    
    private(set) var pagingationState = CurrentValueSubject<PagingationState, Never>(.initialLoading)
    private(set) var currentPage = 0
    private(set) var totalPage = 1
    
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
    func loadCharacters() {
        isLoading = true
        
        Task {
            do {
                let characterResponse = try await useCase.fetchAllCharacters(with: .init(page: nextPage))
                
                guard !characterResponse.results.isEmpty else {
                    characters = []
                    return
                }
                
                currentPage += 1
                
                totalPage = characterResponse.info.pages
                characters.append(contentsOf: characterResponse.results.map(CharacterItemViewModel.init))
                isLoading = false
            } catch {
                self.error.send(error.localizedDescription)
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
