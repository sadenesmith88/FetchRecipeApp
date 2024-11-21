//
//  SavedRecipesSectionView.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/20/24.
//

import SwiftUI

struct SavedRecipesSectionView: View {
  var savedRecipes: [Recipe]
    var body: some View {

          VStack(alignment: .leading) {
              Text("Saved Recipes")
                  .font(.headline)
                  .id("savedRecipes")

              ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 16) {
                      ForEach(savedRecipes) { recipe in
                          RecipeRow(recipe: recipe)
                              .frame(width: 200)
                      }
                  }

              }
          }
          .padding(.horizontal)
          .padding(.vertical)
        

    }
}

