//
//  RecipeRow.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/20/24.
//

import SwiftUI

struct RecipeRow: View {

    let recipe: Recipe
    @State private var isExpanded = false
    @State private var recipeDetails: RecipeDetails?
    @State private var isLoadingDetails = false
    @State private var showingSaved = false
    @EnvironmentObject var viewModel: RecipeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
          HStack(alignment: .top) {

            AsyncImage(url: URL(string: recipe.photo_url_small ?? "")) { image in
              image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                  width: isExpanded ? 200 : 60,
                  height: isExpanded ? 200 : 60
                )
                .cornerRadius(isExpanded ? 12 : 8)
            } placeholder: {
              Color.gray.opacity(0.3)
                .frame(width: isExpanded ? 200 : 60,
                       height: isExpanded ? 200 : 60
                )
                .cornerRadius(isExpanded ? 12 : 8)
            }

            VStack(alignment: .leading) {
              Text(recipe.name)
                .font(.headline)
              Text(recipe.cuisine)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            Spacer()
            HStack {
              Button (action: {
                withAnimation {
                  isExpanded.toggle()
                  if isExpanded && recipeDetails == nil {
                    loadRecipeDetails()
                  }
                }
              }) {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                  .font(.title3)
              }
              .buttonStyle(PlainButtonStyle())

              Button {
                viewModel.toggleSaved(recipe: recipe)
              } label: {
                Image(systemName: viewModel.isSaved(recipe: recipe) ? "heart.fill" : "heart")
                  .font(.title3)
                  .foregroundColor(.red)
              }
              .buttonStyle(PlainButtonStyle())
            }
          }

            if isExpanded {
              if isLoadingDetails {
                ProgressView()
              } else if let details = recipeDetails {
                VStack(alignment: .leading, spacing: 16) {

                  if let youtubeUrl = recipe.youtube_url {
                    Link(destination: URL(string: youtubeUrl)!) {
                      HStack {
                        Text("Watch Video Tutorial")
                        Image(systemName: "play.circle.fill")
                      }
                      .foregroundColor(.white)
                      .padding(.horizontal, 12)
                      .padding(.vertical, 8)
                      .background(Color(.red))
                      .cornerRadius(8)
                    }
                  }

                  //ingredient list
                  VStack(alignment: .leading, spacing: 8) {
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
      }

      .padding(.vertical, 8)
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


