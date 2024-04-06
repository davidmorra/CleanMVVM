// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

public class ApiClient {
    private let session: URLSessionProtocol
    private let baseURL: String = "rickandmortyapi.com"
    
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func perform<T: Decodable, R: Requestable>(_ request: R) async throws -> T {
        let urlRequest = try request.makeURLRequest(host: baseURL)
        let (data, response) = try await session.data(for: urlRequest)
        guard let resp = response as? HTTPURLResponse, (200..<300).contains(resp.statusCode) else {
            throw NetworkError.invalidReponse
        }
                
        let result = try decode(T.self, from: data)
        return result
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw error
        }
    }
}

public enum NetworkError: Error {
    case invalidReponse
}

