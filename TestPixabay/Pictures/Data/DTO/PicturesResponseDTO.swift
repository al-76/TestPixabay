//
//  PicturesResponseDTO.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Foundation

struct PicturesResponseDTO: Codable {
    let hits: [Picture]
}

extension Picture {
    enum CodingKeys: String, CodingKey {
        case imageUrl = "largeImageURL"
        case thumbnailUrl = "previewURL"
        case likesCount = "likes"
        case downloadsCount = "downloads"
        case commentsCount = "comments"

        case id
        case user
        case tags
    }
}
