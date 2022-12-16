//
//  Network.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine
import Foundation

final class Network {
    private let urlCache = URLCache(memoryCapacity: 1024 * 1024 * 10,
                            diskCapacity: 1024 * 1024 * 50)

    func request(url: URL) -> AnyPublisher<Data, Error> {
        loadFromCache(url: url)
            .compactMap { [weak self] data in
                guard let data = data else {
                    return self?.requestAction(url)
                }
                return Just(data) // cached data
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }

    private func requestAction(_ url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { [weak self] result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                self?.saveToCache(url: url,
                                  response: result.response,
                                  data: result.data)
                return result.data
            }
            .eraseToAnyPublisher()
    }

    private func loadFromCache(url: URL) -> AnyPublisher<Data?, Error> {
        Future { [weak urlCache] promise in
            let request = URLRequest(url: url)
            let data = urlCache?.cachedResponse(for: request)?.data
            promise(.success(data))
        }
        .eraseToAnyPublisher()
    }

    private func saveToCache(url: URL, response: URLResponse, data: Data) {
        let request = URLRequest(url: url)
        let cachedData = CachedURLResponse(response: response,
                                           data: data)
        urlCache.storeCachedResponse(cachedData, for: request)
    }
}
