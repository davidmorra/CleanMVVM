//
//  File.swift
//  
//
//  Created by Davit on 24.03.24.
//

import Network
import Foundation
import XCTest

struct MockURLSessionError: Error { }

class MockURLSession: URLSessionProtocol {
    private(set) var capturedURLRequest: URLRequest?
    var stubDataResponse: Result<(Data, URLResponse), Error>?
    var expectation: XCTestExpectation?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        defer {
            expectation?.fulfill()
        }
        self.capturedURLRequest = request
        
        return try stubDataResponse!.get()
    }
}


//MARK: - Helpers
func DataTestDouble() -> Data {
    return Data(UInt8.min...UInt8.max)
}

func HTTPURLResponseTestDouble(statusCode: Int = 200, headerFields: [String: String]? = nil) -> HTTPURLResponse {
    return HTTPURLResponse(url: URLTestDouble(), statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headerFields)!
}

func URLRequestTestDouble() -> URLRequest {
    URLRequest(url: URLTestDouble())
}

func URLResponseTestDouble() -> URLResponse {
    URLResponse(url: URLTestDouble(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

func URLTestDouble() -> URL {
    URL(string: "https://dummy.com")!
}
