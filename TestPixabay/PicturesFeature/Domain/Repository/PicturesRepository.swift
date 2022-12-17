//
//  PicturesRepository.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine

protocol PicturesRepository {
    func read(query: String, page: Int) -> AnyPublisher<[Picture], Error>
}
