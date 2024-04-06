import XCTest
@testable import Network

final class NetworkTests: XCTestCase {
    var apiClient: ApiClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        apiClient = ApiClient(session: mockURLSession)
    }
    
    override func tearDown() {
        mockURLSession = nil
        apiClient = nil
        super.tearDown()
    }
    
    func test_whenMockDataPassed_shouldReturnProperResponse() async throws {
        let mockData = "Mock Data"
        let data = try JSONEncoder().encode(mockData)
        let expectation = self.expectation(description: #function)
        
        mockURLSession.stubDataResponse = .success((data, HTTPURLResponseTestDouble()))
        mockURLSession.expectation = expectation
        
        let response: String = try await apiClient.perform(makeDummyUrlRequset())
        
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertEqual(response, mockData, "Not Equal")
    }
 
    func makeDummyUrlRequset() -> Requestable {
        return StubRequestable()
    }
}

struct StubRequestable: Requestable {
    var path: String = "/path"
}
