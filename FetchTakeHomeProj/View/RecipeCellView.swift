//
//  RecipeCellView.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/13/24.
//

import SwiftUI

struct RecipeCellView: View {
  let recipe: Recipe
    var body: some View {
      VStack(alignment: .leading) {
        Text(recipe.name)
          .font(.headline)
          .padding(.bottom, 4)

        if let photoURLString = recipe.photo_url_large, let photoURL = URL(string: photoURLString) {
          CachedAsyncImage(url: photoURL, placeholder: Image(systemName: "photo"))
            .frame(height: 120)
            .cornerRadius(8)
        }
      }
      .padding()
      .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
      .shadow(radius: 2)
    }
}

