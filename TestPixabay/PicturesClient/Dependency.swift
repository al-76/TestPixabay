//
//  Dependencies.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 27.12.2022.
//

import ComposableArchitecture

extension PicturesClient: DependencyKey {
    static var liveValue = PicturesClient.live
    static var previewValue = PicturesClient.preview
    static var testValue = PicturesClient.test
}

extension DependencyValues {
  var picturesClient: PicturesClient {
    get { self[PicturesClient.self] }
    set { self[PicturesClient.self] = newValue }
  }
}
