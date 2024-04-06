//
//  File.swift
//  
//
//  Created by Davit on 24.03.24.
//

import Foundation

public protocol Requestable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension Requestable {
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    func makeURLRequest(host: String = "test.com") throws -> URLRequest {
        guard let url = makeURL(host: host) else { throw URLError(.badURL) }
        return URLRequest(url: url)
    }
    
    func makeURL(host: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.path = path
        components.host = host
        components.queryItems = queryItems
        return components.url
    }
}

public enum API {
    public enum Character: Requestable {
        case getAllCharacters(page: Int)
        case character(_ id: Int)
        
        public var path: String {
            switch self {
            case .getAllCharacters:
                "/api/character"
            case .character(let id):
                "/api/character/\(id)"
            }
        }
        
        public var queryItems: [URLQueryItem]? {
            switch self {
            case .getAllCharacters(let page):
                return [.init(name: "page", value: "\(page)")]
            case .character: return nil
            }
        }
    }
}
