//
//  CharacterDetailsViewModel.swift
//  MVVMC+Combine
//
//  Created by Davit on 07.03.24.
//

import Foundation
import Domain
import Data_Layer
import Combine

class CharacteresDetailsViewModel {
    struct Header: Hashable {
        let name: String
        let imageURL: String
        let species: String
        let status: String
    }
    
    struct Info: Hashable {
        let origin: Location
        let location: Location
        
        static func == (lhs: CharacteresDetailsViewModel.Info, rhs: CharacteresDetailsViewModel.Info) -> Bool {
            lhs.location.id == rhs.location.id && lhs.origin.id == rhs.origin.id
        }
        
        struct Location: Hashable {
            let id = UUID()
            let name: String
            let url: String
            let iconName: String
        }
    }
    
    struct Episode: Hashable {
        let id: Int
        let name: String
        let episode: String
        let airDate: String
    }
    
    var headerSection = PassthroughSubject<Header, Never>()
    var infoSection = PassthroughSubject<[Info.Location], Never>()
    var episodesSection = PassthroughSubject<[Episode], Never>()
        
    private let characterID: Int
    private let useCase: CharactersUseCaseProtocol
    
    init(characterID: Int,
         useCase: CharactersUseCaseProtocol = CharactersUseCase(charactersRepository: CharactersRepositoryImpl())) {
        self.characterID = characterID
        self.useCase = useCase
    }
    
    func fetchDetails() {
        Task {
            do {
                let response = try await useCase.fetchCharacter(with: characterID)
                headerSection.send(.init(name: response.name, imageURL: response.image, species: response.species, status: response.status.rawValue))
                
//                infoSection.send([
//                    .init(name: response.origin.name, url: response.origin.url, iconName: "globe.americas.fill"),
//                    .init(name: response.location.name, url: response.location.url, iconName: "location.circle.fill")
//                ])
//                episodesSection.send(response.episode.enumerated().map({ index, _ in
//                    Episode.init(id: index, name: "Episode", episode: "S01E02", airDate: Date.now.description)
//                }))
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
