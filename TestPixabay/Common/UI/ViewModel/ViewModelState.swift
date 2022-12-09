//
//  ViewModelState.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 24.11.2022.
//

import Foundation

enum ViewModelState<T> {
    case loading
    case success(T)
    case failure(Error)
}
