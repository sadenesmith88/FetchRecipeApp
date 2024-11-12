//
//  ContentView.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/12/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = RecipeViewModel()
  let columns = [GridItem(.flexible()), GridItem(.flexible())]

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        if viewModel.isFetching {
          ProgressView("Loading Recipes...")
        } else if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
        } else {
          ForEach(viewModel.groupedRecipes.keys.sorted(), id: \.self) { cuisine in
            Section(header: Text(cuisine).font(.title).padding(.top)) {
              LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.groupedRecipes[cuisine] ?? [], id: \.uuid) { recipe in
                  VStack(alignment: .leading) {
                    Text(recipe.name)
                      .font(.headline)
                      .padding(.bottom, 4)
                    if let photoURL = recipe.photo_url_small,
                       let url = URL(string: photoURL) {
                      AsyncImage(url: url) { image in
                        image
                          .resizable()
                          .scaledToFit()
                          .frame(height: 120)
                          .cornerRadius(8)

                      } placeholder: {
                        ProgressView()
                      }
                    }
                  }
                  .padding()
                  .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                  .shadow(radius: 2)
                }
              }
              .padding(.bottom, 16)
            }
          }
        }
      }
      .padding()
      .onAppear {
        viewModel.fetchRecipes()
      }
    }
  }
}
#Preview {
    ContentView()
}
