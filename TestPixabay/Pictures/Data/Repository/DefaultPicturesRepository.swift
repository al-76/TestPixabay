//
//  DefaultPicturesRepository.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine
import Foundation

final class DefaultPicturesRepository: PicturesRepository {
    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func read(query: String, page: Int) -> AnyPublisher<[Picture], Error> {
        network
            .request(url: getApiUrl(query, page))
            .decode(type: PicturesResponseDTO.self, decoder: JSONDecoder())
            .map { $0.hits }
            .eraseToAnyPublisher()
    }

    private func getApiUrl(_ query: String, _ page: Int) -> URL {
        var components = URLComponents(string: "https://pixabay.com/api")!
        components.queryItems = [
            URLQueryItem(name: "key", value: getApiKey()),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(page)")
            ]
        print(components.url!)
        return components.url!
    }

    private func getApiKey() -> String {
        Bundle.main.object(forInfoDictionaryKey: "PixabayApiKey") as? String ??
        "Please insert PixabayApiKey to Info.plist"
    }
}
