//
//  PicturesReducerTests.swift
//  TestPixabayTests
//
//  Created by Vyacheslav Konopkin on 16.12.2022.
//

import Combine
import ComposableArchitecture
import XCTest

@testable import TestPixabay

@MainActor
final class PicturesReducerTests: XCTestCase {
    private var store: TestStore<PicturesReducer.State,
                                 PicturesReducer.Action,
                                    PicturesReducer.State,
                                    PicturesReducer.Action, ()>!

    override func setUp() {
        store = TestStore(initialState: PicturesReducer.State(),
                          reducer: PicturesReducer())
    }

    func testFetch() async {
        // Arrange
        store.dependencies.picturesClient.read = { _, _ in successAnswer(.stub) }

        // Act
        await store.send(.fetch("test")) {
            $0.isLoading = true
            $0.pictures = []
        }

        // Assert
        await store.receive(.fetchResult(.success(.stub))) {
            $0.isLoading = false
            $0.pictures = .stub
        }
    }

    func testFetchError() async {
        // Arrange
        store.dependencies.picturesClient.read = { _, _ in failAnswer() }

        // Act
        await store.send(.fetch("test")) {
            $0.isLoading = true
            $0.pictures = []
        }

        // Assert
        await store.receive(.fetchResult(.failure(TestError.someError))) {
            $0.isLoading = false
            $0.errorMessage = TestError.someError.localizedDescription
        }
    }

    func testFetchMore() async {
        // Arrange
        let data = Array([Picture].stub.prefix(2))
        let addData = Array([Picture].stub.suffix(1))
        store.dependencies.picturesClient.read = { _, _ in successAnswer(data) }
        await store.send(.fetch("test")) {
            $0.isLoading = true
            $0.page = 1
            $0.pictures = []
        }
        await store.receive(.fetchResult(.success(data))) {
            $0.isLoading = false
            $0.pictures = data
        }

        // Act
        store.dependencies.picturesClient.read = { _, _ in successAnswer(addData) }
        await store.send(.fetchMore("test", data.last!)) {
            $0.isLoading = true
            $0.page = 2
            $0.pictures = data
        }

        // Assert
        await store.receive(.fetchResult(.success(data + addData))) {
            $0.isLoading = false
            $0.page = 2
            $0.pictures = data + addData
        }
    }
}
