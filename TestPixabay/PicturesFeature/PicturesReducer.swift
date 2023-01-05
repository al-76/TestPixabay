//
//  PicturesReducer.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 14.12.2022.
//

import Combine
import ComposableArchitecture
import Foundation

struct PicturesReducer: ReducerProtocol {
    struct State: Equatable {
        var pictures: [Picture] = []
        var page: Int = 1
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }

    enum Action: Equatable {
        case fetch(String)
        case fetchMore(String, Picture)
        case fetchResult(TaskResult<[Picture]>)
    }

    @Dependency(\.picturesClient) var picturesClient

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .fetch(query):
            state.isLoading = true
            state.page = 1
            state.errorMessage = nil
            return reduceFetch(page: state.page, query: query)

        case let .fetchMore(query, picture):
            guard !state.isLoading, picture == state.pictures.last else {
                return .none
            }
            state.isLoading = true
            state.page += 1
            state.errorMessage = nil
            return reduceFetch(page: state.page, query: query,
                               pictures: state.pictures)

        case let .fetchResult(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.localizedDescription

        case let .fetchResult(.success(pictures)):
            state.isLoading = false
            state.pictures = pictures
            state.errorMessage = nil
        }

        return .none
    }

    private func reduceFetch(page: Int,
                             query: String,
                             pictures: [Picture] = []) -> EffectTask<Action> {
        picturesClient.read(query, page)
            .map { .fetchResult(.success(pictures + $0)) }
            .catch { Just(.fetchResult(.failure($0))) }
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    }
}
