//
//  CharactersRepositoryProtocol.swift
//  MVVMC+Combine
//
//  Created by Davit on 25.02.24.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func getAllCharacters(with requestValue: CharactersUseCaseRequestValue) async throws -> CharactersResponse
    func getCharacter(_ id: Int) async throws -> Character
    func getCharacters(_ id: [Int]) async throws -> [Character]
    func filterCharacters(_ filter: Filter) async throws -> [Character]
}
