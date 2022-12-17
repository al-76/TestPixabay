//
//  PicturesViewModel.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 23.11.2022.
//

import Combine
import Foundation

final class PicturesViewModel: ObservableObject {
    typealias State = ViewModelState<Data>

    @Published private(set) var state = State.loading

    struct Data: Equatable {
        let pictures: [Picture]
        let page: Int
        let isLoading: Bool
    }

    private let getPictures: any UseCase<(String, Int), [Picture]>

    init(getPictures: some UseCase<(String, Int), [Picture]>) {
        self.getPictures = getPictures
    }
    
    func firstSearch(query: String) {
        switch state {
        case .loading:
            searchAction(query: query)

        default:
            break
        }
    }

    func search(query: String) {
        setInLoading()
        searchAction(query: query)
    }

    func fetchMore(query: String, at picture: Picture) {
        switch state {
        case .success(let data):
            guard !data.isLoading, picture == data.pictures.last else {
                return
            }

            setInLoading()
            searchAction(query: query, data: data)

        default:
            break
        }
    }

    private func searchAction(query: String, data: Data? = nil) {
        let page = (data?.page ?? 0) + 1
        getPictures((query, page))
            .filter { !$0.isEmpty }
            .map { .success(Data(pictures: (data?.pictures ?? []) + $0,
                                 page: page,
                                 isLoading: false)) }
            .catch { Just(.failure($0)).eraseToAnyPublisher() }
            .receive(on: DispatchQueue.main)
            .print()
            .assign(to: &$state)
    }

    private func setInLoading() {
        switch state {
        case .success(let data):
            let newData = Data(pictures: data.pictures,
                               page: data.page,
                               isLoading: true)
            state = .success(newData)

        default:
            break
        }
    }
}
