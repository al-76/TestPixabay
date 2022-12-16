//
//  PicturesRepository.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine

struct PicturesRepository {
    var read: (/* query */String, /* page */Int) -> AnyPublisher<[Picture], Error>
}
