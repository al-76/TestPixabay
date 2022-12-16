//
//  TestPixabayApp.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 23.11.2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct TestPixabayApp: App {
    init() {
        initializePlatform()
    }

    var body: some Scene {
        WindowGroup {
            PicturesView(store: Store(
                initialState: PicturesReducer.State(),
                reducer: PicturesReducer()
            ))
        }
    }
}
