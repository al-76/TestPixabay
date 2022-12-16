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
        let data = [Picture(id: 1000)]
        store.dependencies.picturesRepository.read = { _, _ in successAnswer(data) }

        // Act
        await store.send(.fetch("test")) {
            $0.isLoading = true
            $0.pictures = []
        }

        // Assert
        await store.receive(.fetchResult(data)) {
            $0.isLoading = false
            $0.pictures = data
        }
    }

    func testFetchError() async {
        // Arrange
        let errorMessage = TestError.someError.localizedDescription
        store.dependencies.picturesRepository.read = { _, _ in failAnswer() }

        // Act
        await store.send(.fetch("test")) {
            $0.isLoading = true
            $0.pictures = []
        }

        // Assert
        await store.receive(.failure(errorMessage)) {
            $0.isLoading = false
            $0.errorMessage = errorMessage
        }
    }

    func testFetchMore() async {
        // Arrange
        let data = [Picture(id: 0), Picture(id: 1000)]
        let addData = [Picture(id: 2000)]
        store.dependencies.picturesRepository.read = { _, _ in successAnswer(data) }
        await store.send(.fetch("test")) {
            $0.isLoading = true
            $0.page = 1
            $0.pictures = []
        }
        await store.receive(.fetchResult(data)) {
            $0.isLoading = false
            $0.pictures = data
        }

        // Act
        store.dependencies.picturesRepository.read = { _, _ in successAnswer(addData) }
        await store.send(.fetchMore("test", data.last!)) {
            $0.isLoading = true
            $0.page = 2
            $0.pictures = data
        }

        // Assert
        await store.receive(.fetchResult(data + addData)) {
            $0.isLoading = false
            $0.page = 2
            $0.pictures = data + addData
        }
    }
}
