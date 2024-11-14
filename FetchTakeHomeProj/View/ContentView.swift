//
//  ContentView.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/12/24.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var viewModel: RecipeViewModel
  @State private var searchText = ""


  var filteredCategories: [String] {
    searchText.isEmpty ? viewModel.groupedRecipes.keys.sorted() :
    viewModel.groupedRecipes.keys.filter { category in

      viewModel.groupedRecipes[category]?.contains { recipe in
        recipe.name.localizedCaseInsensitiveContains(searchText)
      } ?? false
    }
  }

  var body: some View {
    NavigationStack {
      Group {
        if viewModel.isFetching {
          ProgressView()
        } else {
          List(filteredCategories, id: \.self) { category in
            Section(header: Text(category)) {
              ForEach(viewModel.groupedRecipes[category] ?? []) { recipe in
                RecipeRow(recipe: recipe)
              }
            }
          }
        }
      }
      .searchable(text: $searchText)
      .navigationTitle("Dessert Recipes")
      .task { await viewModel.fetchRecipes() }
    }
  }
}

struct RecipeRow: View {
  let recipe: Recipe
  @State private var isExpanded = false
  @State private var recipeDetails: RecipeDetails?
  @State private var isLoadingDetails = false
  @EnvironmentObject var viewModel: RecipeViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        AsyncImage(url: URL(string: recipe.photo_url_small ?? "")) { image in
          image.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .cornerRadius(8)
        } placeholder: {
          Color.gray.opacity(0.3)
            .frame(width: 60, height: 60)
        }

        VStack(alignment: .leading) {
          Text(recipe.name)
            .font(.headline)
          Text(recipe.cuisine)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }

        Spacer()

        Button(action: { isExpanded.toggle()

          if isExpanded && recipeDetails == nil {
            loadRecipeDetails()
          }
        }) {
          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
        }
      }

      if isExpanded {
        if isLoadingDetails {
          ProgressView()
        } else if let details = recipeDetails {
          VStack(alignment: .leading, spacing: 16) {

            if let youtubeUrl = recipe.youtube_url {
              Link("", destination: URL(string: youtubeUrl)!)
              Label("Watch Video Tutorial", systemImage: "play.circle.fill")
                .foregroundColor(.red)
            }
          }

          //ingredient list
          VStackLayout(alignment: .leading, spacing: 8) {
            Text("Ingredients")
              .font(.headline)
            ForEach(details.ingredients, id: \.self) { ingredient in
              Text("- \(ingredient)")
                .font(.subheadline)
            }
          }
          VStackLayout(alignment: .leading, spacing: 8) {
            Text("Instructions:")
              .font(.headline)
            Text(details.instructions)
              .font(.subheadline)
          }
          .padding(.vertical)
        }

      }
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(radius: 2)

  }
  private func loadRecipeDetails() {
    isLoadingDetails = true
    Task {
      do {
        recipeDetails = try await viewModel.fetchRecipeDetails(for: recipe)
      } catch {
        print("Error loading recipe details: \(error)")
      }
      isLoadingDetails = false
    }
  }
}

#Preview {
  ContentView()
}
