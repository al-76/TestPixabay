//
//  GetPicturesUseCase.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine

final class GetPicturesUseCase: UseCase {
    private let repository: PicturesRepository

    init(repository: PicturesRepository) {
        self.repository = repository
    }

    func callAsFunction(_ input: (String, Int)) -> AnyPublisher<[Picture], Error> {
        repository.read(query: input.0, page: input.1)
    }
}
