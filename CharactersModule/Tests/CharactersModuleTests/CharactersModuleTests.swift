//
//  CharactersViewModelTests.swift
//  
//
//  Created by Davit on 24.03.24.
//

import XCTest
@testable import Presentation
@testable import Data
@testable import Domain
import Combine

class MockCharactersUseCase: CharactersUseCaseProtocol {
    var callCount = 0
    var response: CharactersResponse = .init(info: .init(count: 0, pages: 0, next: nil, prev: nil), results: [])
    var error: Error?
    var expectation: XCTestExpectation?
    
    func fetchAllCharacters(with requestValue: Domain.CharactersUseCaseRequestValue) async throws -> Domain.CharactersResponse {
        if let error = error {
            expectation?.fulfill()
            throw error
        }
        callCount += 1
        
        expectation?.fulfill()
        
        return response
    }
    
    func fetchCharacter(with id: Int) async throws -> Domain.Character {
        Character.dummy[0]
    }
    
    func verifyFetchAllCharactersCalledOnce(file: StaticString = #file, line: UInt = #line) -> Bool {
        if callCount > 0 {
            XCTFail("Method didn't called", file: file, line: line)
        }
        
        if callCount > 1 {
            XCTFail("Method called \(callCount) times", file: file, line: line)
        }
        
        return callCount == 1
    }
}

final class CharactersModuleTests: XCTestCase {
    var sut: CharactersViewModel!
    var mockCharactersUseCase: MockCharactersUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockCharactersUseCase = MockCharactersUseCase()
        sut = CharactersViewModel(onSelect: { _ in }, useCase: mockCharactersUseCase)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockCharactersUseCase = nil
        cancellables = []
        super.tearDown()
    }
    
    func test_viewmodel_InitialState() {
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.currentPage, 0)
    }
    
    func test_whenActionIsOnAppear_isLoadingShouldBeTrue() async {
        await sut.handleEvent(.onAppear)
        
        XCTAssertTrue(sut.isLoading)
    }

    func test_onAppearEvent_whenResponseIsEmptyCharactersArrayShouldBeEmpty() async throws {
        await sut.handleEvent(.onAppear)
        
        XCTAssertEqual(sut.characters, [])
    }
    
    func test_onAppearEvent_onNonEmptyResponseCurrentPageMustIncrementByOne() async throws {
        let exp = self.expectation(description: "loading did succeed")
        mockCharactersUseCase.expectation = exp
        mockCharactersUseCase.response = .init(info: .init(count: 100, pages: 5, next: nil, prev: nil), results: Character.dummy)
        
        await sut.handleEvent(.onAppear)

        await fulfillment(of: [exp])
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.hasMorePage)
    }
    
    func test_onAppearEvent_onErrorReceivesErrorMessage() async throws {
        let exp = self.expectation(description: "loading did succeec")
        mockCharactersUseCase.expectation = exp
        mockCharactersUseCase.error = MockCharactersResponseError.badRequest
        
        await sut.handleEvent(.onAppear)

        await fulfillment(of: [exp])
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertNotNil(sut.error)
    }
}

private enum MockCharactersResponseError: String, LocalizedError {
    case badRequest
    
    var errorDescription: String? {
        self.rawValue
    }
}

//MARK: - Helpers
private extension Character {
    static var dummy: [Character] {
        return [
            .init(id: 0, name: "Dummy0", status: .Alive, species: "", type: "", gender: .Male, origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [], url: "", created: ""),
            .init(id: 1, name: "Dummy1", status: .Alive, species: "", type: "", gender: .Male, origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [], url: "", created: ""),
            .init(id: 2, name: "Dummy2", status: .Alive, species: "", type: "", gender: .Male, origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [], url: "", created: ""),
            .init(id: 3, name: "Dummy3", status: .Alive, species: "", type: "", gender: .Male, origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [], url: "", created: ""),
            .init(id: 4, name: "Dummy4", status: .Alive, species: "", type: "", gender: .Male, origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [], url: "", created: "")
        ]
    }
}
