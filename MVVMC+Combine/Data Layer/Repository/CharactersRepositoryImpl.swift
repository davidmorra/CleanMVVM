//
//  CharactersRepositoryImpl.swift
//  MVVMC+Combine
//
//  Created by Davit on 26.02.24.
//

import Foundation
import Network
import Domain

class CharactersRepositoryImpl {
    let apiClient: ApiClient
    
    init(apiClient: ApiClient = .init(session: .shared)) {
        self.apiClient = apiClient
    }
}

extension CharactersRepositoryImpl: CharactersRepositoryProtocol {
    
    func getAllCharacters(with requestValue: CharactersUseCaseRequestValue) async throws -> CharactersResponse {
        return try await apiClient.perform(API.Character.getAllCharacters(page: requestValue.page))
    }
    
    func getCharacters(_ id: [Int]) async throws -> [Character] {
        []
    }
    
    func getCharacter(_ id: Int) async throws -> Character {
        fatalError()
    }
    
    func filterCharacters(_ filter: Filter) async throws -> [Character] {
        []
    }
}
