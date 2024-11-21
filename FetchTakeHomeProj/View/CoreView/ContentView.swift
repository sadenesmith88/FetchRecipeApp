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
  @State private var showingFilter = false
  @State private var selectedFilters: Set<String> = [] // Track selected filters
  
  // Filtered categories based on search text and selected filters
  private var filteredCategories: [String] {
    let allCategories = searchText.isEmpty ? viewModel.groupedRecipes.keys.sorted() :
    viewModel.groupedRecipes.keys.filter { category in
      viewModel.groupedRecipes[category]?.contains { recipe in
        recipe.name.localizedCaseInsensitiveContains(searchText)
      } ?? false
    }
    return allCategories.filter { selectedFilters.isEmpty || selectedFilters.contains($0) }.sorted()
  }
  
  var body: some View {
    NavigationStack {
      ScrollViewReader { scrollProxy in
        VStack {
          // MARK: - Header View
          HeaderView(
            showingFilter: $showingFilter,
            scrollProxy: scrollProxy
          )
          if showingFilter {
            FilterViewWrapper(selectedFilters: $selectedFilters, showingFilter: $showingFilter)
          }
          ContentListView(
            filteredCategories: filteredCategories,
            groupedRecipes: viewModel.groupedRecipes,
            savedRecipes: viewModel.savedRecipes)
        }
        .navigationTitle("Dessert Recipes")
      }
    }
    .searchable(text: $searchText)
    .task { await viewModel.fetchRecipes() }
  }
  
  
}
#Preview {
    ContentView()
}

