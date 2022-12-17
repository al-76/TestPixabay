//
//  GetPicturesUseCaseTests.swift
//  TestPixabayTests
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine
import XCTest

@testable import TestPixabay

final class FakePicturesRepository: PicturesRepository {
    var answer: AnyPublisher<[Picture], Error>?

    func read(query: String, page: Int) -> AnyPublisher<[TestPixabay.Picture], Error> {
        return answer ?? Empty().eraseToAnyPublisher()
    }
}

final class GetPicturesUseCaseTests: XCTestCase {
    private let testPictures = [Picture(id: 1000)]
    private var repository: FakePicturesRepository!
    private var useCase: GetPicturesUseCase!

    override func setUp() {
        repository = FakePicturesRepository()
        useCase = GetPicturesUseCase(repository: repository)
    }

    func testCallAsFunction() throws {
        // Arrange
        repository.answer = successAnswer(testPictures)

        // Act
        let result = try awaitPublisher(useCase(("test", 1)))

        // Assert
        XCTAssertEqual(result, testPictures)
    }

    func testCallAsFunctionError() throws {
        // Arrange
        repository.answer = failAnswer()

        // Act
        let result = try awaitError(useCase(("test", 1)))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
}
