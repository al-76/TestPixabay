//
//  ErrorView.swift
//  TestPixabay
//
//  Created by Vyacheslav Konopkin on 24.11.2022.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String

    var body: some View {
        Label {
            Text("Error: \(errorMessage)")
        } icon: {
            Image(systemName: "xmark.app")
                    .foregroundColor(Color.red)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorMessage: URLError(.badURL).localizedDescription)
    }
}
