//
//  CharacterDetailsViewModel.swift
//  MVVMC+Combine
//
//  Created by Davit on 07.03.24.
//

import Foundation
import Combine

class CharacteresDetailsViewModel {
    struct Header {
        let name: String
        let imageURL: String
        let species: String
        let status: String
    }
    
    struct Info {
        let origin: Location
        let location: Location
        
        struct Location {
            let name: String
            let url: String
        }
    }
    
    struct Episode {
        let id: Int
        let name: String
        let episode: String
        let airDate: String
    }
    
    var headerSection = PassthroughSubject<Header, Never>()
    var infoSection = PassthroughSubject<Info, Never>()
    var episodesSection = PassthroughSubject<Episode, Never>()
}
