//
//  ViewModel+onSuccess.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 24.11.2022.
//

import Foundation
import SwiftUI

extension ViewModelState {
    @ViewBuilder
    func onSuccess(@ViewBuilder handler: (T) -> some View) -> some View {
        switch self {
        case .loading:
            ProgressView("Loading...")

        case .success(let data):
            handler(data)

        case .failure(let error):
            ErrorView(error: error)
        }
    }
}
