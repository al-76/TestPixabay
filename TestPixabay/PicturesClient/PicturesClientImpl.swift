//
//  PicturesClientImpl.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine
import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

struct PicturesResponse: Codable {
    let hits: [Picture]
}

private let network = Network()

// MARK: - Live
extension PicturesClient {
    static var live = Self(read: { query, page in
        // Read api key
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "PixabayApiKey") as? String ??
        "Please insert PixabayApiKey to Info.plist"

        // Build URL
        var components = URLComponents(string: "https://pixabay.com/api")!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        // Do a request
        return network
            .request(url: components.url!)
            .decode(type: PicturesResponse.self, decoder: JSONDecoder())
            .map { $0.hits }
            .eraseToAnyPublisher()
    })
}

// MARK: - Preview
extension PicturesClient {
    static var preview = Self(read: { _, _ in
        Just(.stub)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    })
}

// MARK: - Test
extension PicturesClient {
    static var test = Self(read: unimplemented("TestPicturesClient"))
}

