//
//  Characters.swift
//  MVVMC+Combine
//
//  Created by Davit on 25.02.24.
//

import Foundation

// MARK: - Characters
public struct CharactersResponse: Decodable {
    public let info: Info
    public let results: [Character]
}

// MARK: - Info
public struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Result
public struct Character: Decodable {
    public let id: Int
    public let name: String
    public let status: Status
    public let species: String
    public let type: String
    public let gender: Gender
    public let origin: Location
    public let location: Location
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
}

public enum Gender: String, Codable {
    case Female
    case Male
    case Genderless
    case unknown
}

// MARK: - Location
public struct Location: Decodable {
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

public enum Status: String, Codable {
    case Alive
    case Dead
    case unknown
}

public struct Filter: Encodable {
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
}
