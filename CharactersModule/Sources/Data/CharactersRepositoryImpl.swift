//
//  CharactersRepositoryImpl.swift
//  MVVMC+Combine
//
//  Created by Davit on 26.02.24.
//

import Foundation
import Network
import Domain

public class CharactersRepositoryImpl {
    private let apiClient: ApiClient
    
    public init(apiClient: ApiClient = .init(session: .shared)) {
        self.apiClient = apiClient
    }
}

extension CharactersRepositoryImpl: CharactersRepositoryProtocol {
    
    public func getAllCharacters(with requestValue: CharactersUseCaseRequestValue) async throws -> CharactersResponse {
        let charactersResponse: CharactersResponseDTO = try await apiClient.perform(API.Character.getAllCharacters(page: requestValue.page))
        return charactersResponse.toDomain()
    }
    
    public func getCharacters(_ id: [Int]) async throws -> [Character] {
        []
    }
    
    public func getCharacter(_ id: Int) async throws -> Character {
        let response: CharactersResponseDTO.CharactersDTO = try await apiClient.perform(API.Character.character(id))
        return response.toDomain()
    }
    
    public func filterCharacters(_ filter: Filter) async throws -> [Character] {
        []
    }
}
