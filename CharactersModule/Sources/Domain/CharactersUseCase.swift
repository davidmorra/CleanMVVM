//
//  CharactersUseCase.swift
//  MVVMC+Combine
//
//  Created by Davit on 25.02.24.
//

import Foundation

public protocol CharactersUseCaseProtocol {
    func fetchAllCharacters(with requestValue: CharactersUseCaseRequestValue) async throws -> CharactersResponse
    func fetchCharacter(with id: Int) async throws -> Character
}

public final class CharactersUseCase: CharactersUseCaseProtocol {
    
    private let charactersRepository: CharactersRepositoryProtocol
    
    public init(charactersRepository: CharactersRepositoryProtocol) {
        self.charactersRepository = charactersRepository
    }
    
    public func fetchAllCharacters(with requestValue: CharactersUseCaseRequestValue) async throws -> CharactersResponse {
        return try await charactersRepository.getAllCharacters(with: requestValue)
    }
    
    public func fetchCharacter(with id: Int) async throws -> Character {
        return try await charactersRepository.getCharacter(id)
    }
}

public struct CharactersUseCaseRequestValue {
    public let page: Int
    
    public init(page: Int) {
        self.page = page
    }
}
