//
//  CharacteresDIContainer.swift
//  MVVMC+Combine
//
//  Created by Davit on 09.03.24.
//

import Network
import Domain
import Data

final public class CharacteresDIContainer {
    let apiClient: ApiClient
    
    public init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func makeCharactersRepository() -> CharactersRepositoryProtocol {
        return CharactersRepositoryImpl(apiClient: apiClient)
    }
    
    func makeCharactersUseCase() -> CharactersUseCase {
        let charactersRepository = makeCharactersRepository()
        return CharactersUseCase(charactersRepository: charactersRepository)
    }
}

extension CharacteresDIContainer: CharactersFlowCoordinatorDependencies {
    /// Character Screen
    public func makeCharactersViewController(onSelect: @escaping ((Int) -> Void)) -> CharactersViewController {
        CharactersViewController(viewmodel: makeCharactersViewModel(onSelect: onSelect))
    }
    
    func makeCharactersViewModel(onSelect: @escaping ((Int) -> Void)) -> CharactersViewModel {
        CharactersViewModel(onSelect: onSelect, useCase: makeCharactersUseCase())
    }
    
    // Character Detail Screen
    public func makeCharactersDetailsViewController(for characterID: Int) -> CharacterDetailsViewController {
        CharacterDetailsViewController(viewmodel: makeCharacterDetailsViewModel(for: characterID))
    }
    
    func makeCharacterDetailsViewModel(for characterID: Int) -> CharacteresDetailsViewModel {
        CharacteresDetailsViewModel(characterID: characterID)
    }
}
