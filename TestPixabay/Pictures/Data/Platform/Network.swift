//
//  Network.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine
import Foundation

protocol Network {
    func request(url: URL) -> AnyPublisher<Data, Error>
}
