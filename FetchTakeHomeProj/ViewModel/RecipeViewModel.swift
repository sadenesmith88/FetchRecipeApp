//
//  RecipeViewModel.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/12/24.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
  @Published var groupedRecipes: [String: [Recipes]] = [:]
  @Published var isFetching = false
  @Published var errorMessage: String? = nil

  func fetchRecipes() {
    print("fetchrecipes called")
    self.isFetching = true
    self.errorMessage = nil

    Task {
      do {
        print("fetching recipes from APIService")
        let fetchedRecipes = try await APIService.shared.getInfo()
        print("Fetched recipes count: \(fetchedRecipes.count)")

        self.groupedRecipes = Dictionary(grouping: fetchedRecipes) { $0.cuisine }
        self.isFetching = false

       
        
      } catch {
        print("Error: \(error.localizedDescription)")

          self.errorMessage = "Sorry we couldnt fetch your recipe"
          self.isFetching = false

      }
    }
  }
}
