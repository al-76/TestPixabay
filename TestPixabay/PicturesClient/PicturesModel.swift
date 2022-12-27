//
//  PicturesModel.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Foundation

struct Picture: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let imageUrl: String
    let thumbnailUrl: String
    let user: String
    let tags: String
    let likesCount: Int
    let downloadsCount: Int
    let commentsCount: Int
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

// MARK: - Stub data
extension Array where Element == Picture {
    static let stub = [
        Picture(id: 1850235,
                imageUrl: "https://pixabay.com/get/g365733175b029172c69a514dce8cdc985c63b9e14bd51d628aa4f6c80ad3dc9997aebd7e98a89494af29a57a777b7dd3553ba90f8545313047f29d520d9089bb_1280.jpg",
                thumbnailUrl: "https://cdn.pixabay.com/photo/2016/11/22/19/33/whale-1850235_150.jpg",
                user: "Pexels",
                tags: "whale, mammal, animal",
                likesCount: 297,
                downloadsCount: 49524,
                commentsCount: 50),
        Picture(id: 2051760,
                imageUrl: "https://pixabay.com/get/g4fca356e95b0007214e0ddb8ca3b3ff60ea0273fed85ee4869fd1e2bcd1a71a09f4c45d4109a8376146e168f5010a54c0e4fc7c69975d22803cc2b4d9250429f_1280.jpg",
                thumbnailUrl: "https://cdn.pixabay.com/photo/2017/02/09/12/07/ocean-2051760_150.jpg",
                user: "Three-shots",
                tags: "ocean, blue whale, sea",
                likesCount: 616,
                downloadsCount: 103929,
                commentsCount: 107),
        Picture(id: 2052650,
                imageUrl: "https://pixabay.com/get/g90cbc98d1cbe2435fb2304761f9780d4458e759af72d245ba5d450b87b0b56733e8246ec32c5c7fd61f9b78ec2af5607035534cba9d397c5f1c4a3336fc7db10_1280.jpg",
                thumbnailUrl: "https://cdn.pixabay.com/photo/2017/02/09/15/10/sea-2052650_150.jpg",
                user: "12019",
                tags: "sea, humpback whale, tail",
                likesCount: 857,
                downloadsCount: 173408,
                commentsCount: 86)
    ]
}
