//
//  ViewModelState+Equatable.swift
//  TestPixabayTests
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

@testable import TestPixabay

extension ViewModelState: Equatable where T: Equatable {
    public static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.failure(_), .failure(_)):
            return true
        case let (.success(a), .success(b)):
            return a == b
        default:
            return false
        }
    }
}
