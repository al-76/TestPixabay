//
//  PicturesView.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 23.11.2022.
//

import ComposableArchitecture
import SwiftUI

struct PicturesView: View {
    let store: StoreOf<PicturesReducer>

    @State var searchText = ""

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        WithViewStore(store) { store in
            NavigationStack {
                if let message = store.errorMessage {
                    ErrorView(errorMessage: message)
                }
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(store.pictures) { picture in
                            NavigationLink(value: picture) {
                                ResizableImageView(url: picture.thumbnailUrl)
                            }
                            .onAppear {
                                store.send(.fetchMore(searchText, picture))
                            }
                        }
                    }
                }
                .navigationDestination(for: Picture.self) {
                    PictureDetailsView(picture: $0)
                }
                if store.isLoading {
                    ProgressView()
                }
            }
            .searchable(text: $searchText)
            .onSubmit(of: .search) {
                store.send(.fetch(searchText))
            }
            .onAppear {
                store.send(.fetch(searchText))
            }
        }
    }
}

struct PicturesView_Previews: PreviewProvider {
    static var previews: some View {
        PicturesView(store: Store(initialState: PicturesReducer.State(),
                                  reducer: PicturesReducer()),
                     searchText: "forest")
    }
}
