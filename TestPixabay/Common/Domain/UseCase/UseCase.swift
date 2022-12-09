//
//  UseCase.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Combine

protocol UseCase<Input, Output> {
    associatedtype Input
    associatedtype Output

    func callAsFunction(_ input: Input) -> AnyPublisher<Output, Error>
}
