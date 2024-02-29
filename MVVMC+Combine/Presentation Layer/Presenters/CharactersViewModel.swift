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

struct CharacterItemViewModel: Hashable {
    let id: Int
    let name: String
    let imageUrl: String
    let species: String
    
    init(_ model: Character) {
        self.id = model.id
        self.name = model.name
        self.imageUrl = model.image
        self.species = model.species
    }
}

final class CharactersViewModel {
     @Published var charactersArray = [CharacterItemViewModel]()
    
    private let currentPage = 0
    private var totalPage: Int?
    
    let useCase: CharactersUseCaseProtocol
    
    init(useCase: CharactersUseCaseProtocol = CharactersUseCase(charactersRepository: CharactersRepositoryImpl())) {
        self.useCase = useCase
    }
    
    func loadCharacters() async throws {
        let characterResponse = try await useCase.fetchAllCharacters(with: .init(page: 0))
        charactersArray = characterResponse.results.map(CharacterItemViewModel.init)
    }
}
