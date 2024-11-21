//
//  ContentListView.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/20/24.
//

import SwiftUI

struct ContentListView: View {
  @EnvironmentObject var viewModel: RecipeViewModel
  let filteredCategories: [String]
  let groupedRecipes: [String: [Recipe]]
  let savedRecipes: [Recipe]
  
  @State private var scrollToSavedRecipes = false
  
  var body: some View {
    if viewModel.isFetching {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }else {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          // Display filtered categories
          ForEach(filteredCategories, id: \.self) { category in
            Section(header: Text(category).font(.headline)) {
              ForEach(groupedRecipes[category] ?? []) { recipe in
                RecipeRow(recipe: recipe)
              }
            }
            .background(
              RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 3)
            )
            .padding(.horizontal)
          }
          
          // Display saved recipes at the bottom
          if !savedRecipes.isEmpty {
            SavedRecipesSectionView(savedRecipes: savedRecipes)
              .padding(.top, 16)
          }
        }
        .padding(.top, 16)
      }
    }
  }
}


