//
//  PicturesView.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 23.11.2022.
//

import SwiftUI

struct PicturesView: View {
    @StateObject private var viewModel = PicturesViewModel(
        getPictures: GetPicturesUseCase(
            repository: DefaultPicturesRepository(network: DefaultNetwork())))

    @State var searchText = ""

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        viewModel.state.onSuccess { data in
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(data.pictures) { picture in
                            NavigationLink(value: picture) {
                                ResizableImageView(url: picture.thumbnailUrl)
                            }
                            .onAppear {
                                viewModel.fetchMore(query: searchText, at: picture)
                            }
                        }
                    }
                }
                .navigationDestination(for: Picture.self) {
                    PictureDetailsView(picture: $0)
                }
                if data.isLoading {
                    ProgressView()
                }
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            viewModel.search(query: searchText)
        }
        .onAppear {
            viewModel.firstSearch(query: searchText)
        }
    }
}

struct PicturesView_Previews: PreviewProvider {
    static var previews: some View {
        PicturesView(searchText: "forest")
    }
}
