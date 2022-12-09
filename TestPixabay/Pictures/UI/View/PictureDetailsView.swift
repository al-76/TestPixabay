//
//  PictureDetailsView.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 24.11.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PictureDetailsView: View {
    let picture: Picture

    var body: some View {
        VStack(alignment: .leading) {
            ResizableImageView(url: picture.imageUrl)

            Text(picture.user)
            Divider()
            TagsView(tags: picture.tags)

            Divider()
            Label {
                Text("\(picture.likesCount)")
            } icon: {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color.red)
            }
            Label {
                Text("\(picture.downloadsCount)")
            } icon: {
                Image(systemName: "icloud.and.arrow.down")
                    .foregroundColor(Color.green)
            }
            Label {
                Text("\(picture.commentsCount)")
            } icon: {
                Image(systemName: "text.bubble")
                    .foregroundColor(Color.blue)
            }
        }
        .padding()
    }
}

struct PictureDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PictureDetailsView(picture: Picture(id: 1000,
                                            imageUrl: "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg",
                                            thumbnailUrl: "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg",
                                            user: "user",
                                            tags: "tagtag, tag2, tagtag3",
                                            likesCount: 100500,
                                            downloadsCount: 10000,
                                            commentsCount: 1024))
    }
}
