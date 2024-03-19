//
//  File.swift
//  
//
//  Created by Davit on 29.02.24.
//

import Foundation
import Domain

public struct CharactersResponseDTO: Decodable {
    public let info: PageInfoDTO
    public let results: [CharactersDTO]
}

public extension CharactersResponseDTO {
    struct CharactersDTO: Decodable {
        public let id: Int
        public let name: String
        public let status: StatusDTO
        public let species: String
        public let type: String
        public let gender: GenderDTO
        public let origin: LocationDTO
        public let location: LocationDTO
        public let image: String
        public let episode: [String]
        public let url: String
        public let created: String
    }
    
    struct PageInfoDTO: Decodable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
}

public extension CharactersResponseDTO.PageInfoDTO {
    func toDomain() -> Info {
        .init(count: count, pages: pages, next: next, prev: prev)
    }
}

public extension CharactersResponseDTO.CharactersDTO {
    enum GenderDTO: String, Codable {
        case Female
        case Male
        case Genderless
        case unknown
        
        func toDomain() -> Gender {
            switch self {
            case .Female: return .Female
            case .Genderless: return .Genderless
            case .Male: return .Male
            case .unknown: return .unknown
            }
        }
    }
    
    struct LocationDTO: Decodable {
        let name: String
        let url: String
        
        func toDomain() -> Location {
            .init(name: name, url: url)
        }
    }
    
    enum StatusDTO: String, Decodable {
        case Alive
        case Dead
        case unknown
        
        func toDomain() -> Status {
            switch self {
            case .Alive: return .Alive
            case .Dead: return .Dead
            case .unknown: return .unknown
            }
        }
    }
    
    func toDomain() -> Character {
        return .init(id: id, name: name, status: status.toDomain(), species: species, type: type, gender: gender.toDomain(), origin: location.toDomain(), location: location.toDomain(), image: image, episode: episode, url: url, created: created)
    }
}

extension CharactersResponseDTO {
    func toDomain() -> CharactersResponse {
        return .init(info: info.toDomain(), results: results.map { $0.toDomain() })
    }
}
