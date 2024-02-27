//
//  CharactersViewModel.swift
//  MVVMC+Combine
//
//  Created by Davit on 26.02.24.
//

import Foundation
import Combine
import Domain

final class CharactersViewModel {
    var characters = PassthroughSubject<CharactersResponse, Error>()
     @Published var charactersArray = [Character]()
    
    private let currentPage = 0
    private var totalPage: Int?
    
    let useCase: CharactersUseCaseProtocol
    
    init(useCase: CharactersUseCaseProtocol = CharactersUseCase(charactersRepository: CharactersRepositoryImpl())) {
        self.useCase = useCase
    }
    
    func loadCharacters() async throws {
        let characterResponse = try await useCase.fetchAllCharacters(with: .init(page: 0))
        characters.send(characterResponse)
        charactersArray = characterResponse.results
    }
}
