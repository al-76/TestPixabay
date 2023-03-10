//
//  XCTestCase+Await.swift
//
// Inspired:
// https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code/
//
import Combine
import XCTest

enum TestAwaitError: Error {
    case unexpectedResult
}

extension XCTestCase {
    @discardableResult
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        let result = awaitAction(publisher, timeout)

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }

    @discardableResult
    func awaitError<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Failure {
        let result = awaitAction(publisher, timeout)

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        if case .failure(let error) = unwrappedResult {
            return error
        }

        throw TestAwaitError.unexpectedResult
    }

    private func awaitAction<T: Publisher>(
        _ publisher: T,
        _ timeout: TimeInterval) -> Result<T.Output, T.Failure>? {
        var result: Result<T.Output, T.Failure>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                    expectation.fulfill()
                    break
                case .finished:
                    break
                }
            },
            receiveValue: { value in
                result = .success(value)
                expectation.fulfill()
            }
        )

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        return result
    }
}

extension XCTestCase {
    @discardableResult
    func awaitPublisherCount<T: Publisher>(
        _ publisher: T,
        count: Int,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        action: (() -> Void)? = nil
    ) throws -> [T.Output] {
        let result = awaitActionAll(publisher, count, timeout) {
            action?()
        }

        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }

    private func awaitActionAll<T: Publisher>(
        _ publisher: T,
        _ count: Int,
        _ timeout: TimeInterval,
        _ action: () -> Void) -> Result<[T.Output], T.Failure>? {
        var result: Result<[T.Output], T.Failure>?
        let expectation = self.expectation(description: "Awaiting publisher with all values")
        var values = [T.Output]()

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                    expectation.fulfill()
                    break
                case .finished:
                    break
                }
            },
            receiveValue: { value in
                values.append(value)

                guard values.count == count else { return }
                result = .success(values)
                expectation.fulfill()
            }
        )

        action()

        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        return result
    }
}

/*
Example:
class SimpleViewModelTests: XCTestCase {
    class SimpleViewModel {
        @Published var testVar = ""
    }

    func testValues() throws {
        // Arrange
        let vm = SimpleViewModel()

        // Act
        let result = try awaitPublisherCount(vm.$testVar.dropFirst()/* drop initial */, count: 2) {
            vm.testVar = "test"
            vm.testVar = "test2"
        }

        // Assert
        XCTAssertEqual(result, ["test", "test2"])
    }

    func testValue() throws {
        // Arrange
        let vm = SimpleViewModel()

        // Act
        vm.testVar = "test"
        let result = try awaitPublisher(vm.$testVar)

        // Assert
        XCTAssertEqual(result, "test")
    }
}
*/
