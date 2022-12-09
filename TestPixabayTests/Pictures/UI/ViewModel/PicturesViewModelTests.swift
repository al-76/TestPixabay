//
//  PicturesViewModelTests.swift
//  TestPixabayTests
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine
import XCTest

@testable import TestPixabay

final class FakeGetPictures: UseCase {
    var answer: AnyPublisher<[Picture], Error>?
    var callCount = 0

    func callAsFunction(_ input: (String, Int)) -> AnyPublisher<[Picture], Error> {
        defer { callCount += 1 }
        return answer ?? Empty().eraseToAnyPublisher()
    }
}

final class PicturesViewModelTests: XCTestCase {
    private let testData = PicturesViewModel.Data(pictures: [Picture(id: 1000)],
                                                  page: 1,
                                                  isLoading: false)
    private var getPictures: FakeGetPictures!
    private var viewModel: PicturesViewModel!

    override func setUp() {
        getPictures = FakeGetPictures()
        viewModel = PicturesViewModel(getPictures: getPictures)
    }

    func testLoadingState() throws {
        // Arrange

        // Act
        let result = try awaitPublisher(viewModel.$state)

        // Assert
        XCTAssertEqual(result, .loading)
    }

    func testFirstSearch() throws {
        // Arrange
        getPictures.answer = successAnswer(testData.pictures)

        // Act
        viewModel.firstSearch(query: "test")

        // Assert
        let result = try awaitPublisher(viewModel.$state.dropFirst())
        XCTAssertEqual(result, .success(testData))
    }

    func testFirstSearchError() throws {
        // Arrange
        getPictures.answer = failAnswer()

        // Act
        viewModel.firstSearch(query: "test")

        // Assert
        let result = try awaitPublisher(viewModel.$state.dropFirst())
        XCTAssertEqual(result, .failure(TestError.someError))
    }

    func testFirstSearchTwice() throws {
        // Arrange
        getPictures.answer = successAnswer(testData.pictures)

        // Act
        viewModel.firstSearch(query: "test1")
        try awaitPublisher(viewModel.$state.dropFirst())
        viewModel.firstSearch(query: "test2")

        // Assert
        XCTAssertEqual(getPictures.callCount, 1)
    }

    func testSearch() throws {
        // Arrange
        getPictures.answer = successAnswer(testData.pictures)

        // Act
        viewModel.search(query: "test")

        // Assert
        let result = try awaitPublisher(viewModel.$state.dropFirst())
        XCTAssertEqual(result, .success(testData))
    }

    func testSearchError() throws {
        // Arrange
        getPictures.answer = failAnswer()

        // Act
        viewModel.search(query: "test")

        // Assert
        let result = try awaitPublisher(viewModel.$state.dropFirst())
        XCTAssertEqual(result, .failure(TestError.someError))
    }

    func testFetchMore() throws {
        // Arrange
        let expectedData = PicturesViewModel
            .Data(pictures: testData.pictures + testData.pictures,
                  page: testData.page + 1,
                  isLoading: false)
        getPictures.answer = successAnswer(testData.pictures)
        viewModel.firstSearch(query: "test1")
        try awaitPublisher(viewModel.$state.dropFirst())

        // Act
        viewModel.fetchMore(query: "test", at: testData.pictures[0])

        // Assert
        let result = try awaitPublisher(viewModel.$state.dropFirst())
        XCTAssertEqual(result, .success(expectedData))
    }

    func testFetchMoreSkipOnState() throws {
        // Arrange
        getPictures.answer = successAnswer(testData.pictures)

        // Act
        viewModel.fetchMore(query: "test", at: testData.pictures[0])

        // Assert
        XCTAssertEqual(getPictures.callCount, 0)
    }

    func testFetchMoreSkipOnIsLoading() throws {
        // Arrange
        getPictures.answer = successAnswer(testData.pictures)
        viewModel.search(query: "test")

        // Act
        viewModel.fetchMore(query: "test", at: testData.pictures[0])

        // Assert
        XCTAssertEqual(getPictures.callCount, 1)
    }

    func testFetchMoreSkipOnNotLast() throws {
        // Arrange
        getPictures.answer = successAnswer(testData.pictures)
        viewModel.search(query: "test")

        // Act
        viewModel.fetchMore(query: "test", at: Picture(id: 10))

        // Assert
        XCTAssertEqual(getPictures.callCount, 1)
    }
}
