//
//  RecipeViewModel.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/12/24.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
  @Published private (set) var groupedRecipes: [String: [Recipe]] = [:]
  @Published private(set) var isFetching = false
  @Published var errorMessage: String?
  private var recipeDetailsCache: [String: RecipeDetails] = [:]


  func fetchRecipes() {
    Task {
      isFetching = true
      do {
        let recipes = try await APIService.shared.getInfo()
        groupedRecipes = Dictionary(grouping: recipes) { $0.dessertType }

      } catch {
        errorMessage = error.localizedDescription
      }
      isFetching = false
    }
  }

  func fetchRecipeDetails(for recipe: Recipe) async throws -> RecipeDetails {

    if let cached = recipeDetailsCache[recipe.uuid] {
      return cached
    }

    guard let sourceUrl = recipe.source_url else {
      throw URLError(.badURL)
    }

    let details = try await APIService.shared.fetchRecipeDetails(from: sourceUrl)
    recipeDetailsCache[recipe.uuid] = details
    return details 
  }
}


