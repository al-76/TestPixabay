//
//  DefaultPicturesRepositoryTests.swift
//  TestPixabayTests
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine
import XCTest

@testable import TestPixabay

final class FakeNetwork: Network {
    var answer: AnyPublisher<Data, Error>?

    func request(url: URL) -> AnyPublisher<Data, Error> {
        return answer ?? Empty().eraseToAnyPublisher()
    }
}

final class DefaultPicturesRepositoryTests: XCTestCase {
    private var network: FakeNetwork!
    private var repository: DefaultPicturesRepository!

    override func setUp() {
        network = FakeNetwork()
        repository = DefaultPicturesRepository(network: network)
    }

    func testRequest() throws {
        // Arrange
        let testPictures = [Picture(id: 1000)]
        let testData = Data("""
        {
            "hits": [{
                "id": \(testPictures[0].id),
                "user": "\(testPictures[0].user)",
                "tags": "\(testPictures[0].tags)",
                "largeImageURL": "\(testPictures[0].imageUrl)",
                "previewURL": "\(testPictures[0].thumbnailUrl)",
                "likes": \(testPictures[0].likesCount),
                "downloads": \(testPictures[0].downloadsCount),
                "comments": \(testPictures[0].commentsCount)
            }]
        }
        """.utf8)
        network.answer = successAnswer(testData)

        // Act
        let result = try awaitPublisher(repository.read(query: "test", page: 1))

        // Assert
        XCTAssertEqual(result, testPictures)
    }

    func testRequestError() throws {
        // Arrange
        network.answer = failAnswer()

        // Act
        let result = try awaitError(repository.read(query: "test", page: 1))

        // Assert
        XCTAssertEqual(result as? TestError, TestError.someError)
    }
}
