//
//  Picture+init.swift
//  TestPixabayTests
//
//  Created by Vyacheslav Konopkin on 25.11.2022.
//

import Foundation

@testable import TestPixabay

extension Picture {
    init(id: Int) {
        self.init(id: id,
                  imageUrl: "\(id)imageUrl",
                  thumbnailUrl: "\(id)thumbnailUrl",
                  user: "\(id)user",
                  tags: "\(id)tags",
                  likesCount: 128,
                  downloadsCount: 256,
                  commentsCount: 512)
    }
}
