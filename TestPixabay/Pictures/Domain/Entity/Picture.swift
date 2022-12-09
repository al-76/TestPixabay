//
//  Picture.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 24.11.2022.
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
