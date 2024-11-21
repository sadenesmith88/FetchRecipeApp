//
//  CategorySectionView.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/20/24.
//

import SwiftUI

struct CategorySectionView: View {
  var category: String
  var groupedRecipes: [String: [Recipe]]
    var body: some View {

          Section(header: Text(category)) {
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
    }



