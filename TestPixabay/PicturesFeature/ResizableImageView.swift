//
//  ResizableImageView.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 02.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ResizableImageView: View {
    let url: String

    var body: some View {
        WebImage(url: URL(string: url))
            .placeholder { ProgressView() }
            .resizable()
            .scaledToFit()
            .transition(.fade(duration: 0.5))
            .cornerRadius(8.0)
            .padding(2)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ResizableImageView(url: "")
    }
}
