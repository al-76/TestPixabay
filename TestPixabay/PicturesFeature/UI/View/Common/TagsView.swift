//
//  TagsView.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 24.11.2022.
//

import SwiftUI

struct TagsView: View {
    let tags: String
    let tagsLineLimit: Int?

    private let columns = [GridItem(.adaptive(minimum: 70))]

    init(tags: String, tagsLineLimit: Int? = nil) {
        self.tags = tags
        self.tagsLineLimit = tagsLineLimit
    }

    var body: some View {
        Text(tags)
            .lineLimit(tagsLineLimit)
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView(tags: "fftag1, fftag2, tag3, tag4, tag5")
    }
}
