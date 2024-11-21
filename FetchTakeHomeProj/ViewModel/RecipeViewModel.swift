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
  @Published var savedRecipes: [Recipe] = []
  @Published private(set) var isFetching = false
  @Published var errorMessage: String?
  private var recipeDetailsCache: [String: RecipeDetails] = [:]

//toggle saved state
  func toggleSaved(recipe: Recipe) {
    if savedRecipes.contains(where: { $0.id == recipe.id }) {
      savedRecipes.removeAll { $0.id == recipe.id }
    } else {
      savedRecipes.append(recipe)
    }
  }

  //check if recipe is saved
  func isSaved(recipe: Recipe) -> Bool {
    savedRecipes.contains { $0.id == recipe.id }
  }
  
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


