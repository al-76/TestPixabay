//
//  DefaultPicturesRepository.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine
import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

extension PicturesRepository: DependencyKey {
    static var liveValue: PicturesRepository { Self(read: { query, page in
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
        let url = components.url!
        print(url)

        // Do a request
        return network
            .request(url: url)
            .decode(type: PicturesResponseDTO.self, decoder: JSONDecoder())
            .map { $0.hits }
            .eraseToAnyPublisher()
    }) }

    static var testValue: PicturesRepository {
        Self(read: unimplemented("PicturesRepository.read"))
    }
}

private let network = Network()

extension DependencyValues {
  var picturesRepository: PicturesRepository {
    get { self[PicturesRepository.self] }
    set { self[PicturesRepository.self] = newValue }
  }
}
