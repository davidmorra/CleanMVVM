//
//  RequestableTests.swift
//  
//
//  Created by Davit on 25.03.24.
//

import XCTest
import Network

struct MockEndpoint: Requestable {
    var path: String
    var queryItems: [URLQueryItem]? = nil
}

final class RequestableTests: XCTestCase {
    
    func test_makeBasicURL() {
        let host = "test.com"
        let request = MockEndpoint(path: "/path")

        XCTAssertNotNil(request.makeURL(host: host))
    }
    
    func test_makeURLWithPageQuery() {
        let host = "test.com"
        let request = MockEndpoint(path: "/path", queryItems: [.init(name: "page", value: "1")])
        guard let url = request.makeURL(host: host) else {
            XCTFail("Couldn't make url")
            return
        }
        
        XCTAssertEqual(url.absoluteString, "https://test.com/path?page=1")
    }
    
    func test_makeURLWithTwoQueries() {
        let queries = [URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "status", value: "alive")]
        guard let url = createURLRequestWithQuery(path: "/path", query: queries) else {
            XCTFail("Couldn't make url")
            return
        }

        XCTAssertEqual(url.absoluteString, "https://test.com/path?page=1&status=alive")
    }
    
    func test_urlRequestThrowsBadURLErrorWhenURLIsWrong() {
        let request = createURLRequest(path: "dummypath")
        
        
        XCTAssertThrowsError(try request.makeURLRequest(host: "test.com")) { error in
            XCTAssertEqual(error as! URLError, URLError(.badURL))
        }
    }

    // helpers
    func createURLRequest(path: String) -> Requestable {
        MockEndpoint(path: path)
    }
    
    func createURLRequestWithQuery(path: String, query: [URLQueryItem]) -> URL? {
        let host = "test.com"
        let request = MockEndpoint(path: "/path", queryItems: query)
                
        return request.makeURL(host: host)
    }
}
