//
//  Characters.swift
//  MVVMC+Combine
//
//  Created by Davit on 25.02.24.
//

import Foundation

// MARK: - Characters
struct CharactersResponse: Decodable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Result
struct Character: Decodable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum Gender: String, Codable {
    case Female
    case Male
    case Genderless
    case unknown
}

// MARK: - Location
struct Location: Decodable {
    let name: String
    let url: String
}

//enum Species: String, Codable {
//    case Alien
//    case Human
//    case Humanoid
//    case unknown
//    case Poopybutthole
//}

enum Status: String, Codable {
    case Alive
    case Dead
    case unknown
}

struct Filter: Encodable {
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
}
