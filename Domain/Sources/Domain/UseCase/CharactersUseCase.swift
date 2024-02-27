//
//  CharactersUseCase.swift
//  MVVMC+Combine
//
//  Created by Davit on 25.02.24.
//

import Foundation

protocol CharactersUseCaseProtocol {
    func fetchAllCharacters(with requestValue: CharactersUseCaseRequestValue) async throws -> CharactersResponse
}

final class CharactersUseCase: CharactersUseCaseProtocol {
    
    let charactersRepository: CharactersRepositoryProtocol
    
    init(charactersRepository: CharactersRepositoryProtocol = CharactersRepositoryImpl()) {
        self.charactersRepository = charactersRepository
    }
    
    func fetchAllCharacters(with requestValue: CharactersUseCaseRequestValue) async throws -> CharactersResponse {
        return try await charactersRepository.getAllCharacters(with: requestValue)
    }
}

struct CharactersUseCaseRequestValue {
    let page: Int
}
