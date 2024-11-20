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
  @State private var selectedFilters: Set<String> = [] //track selected filters

  var filteredCategories: [String] {

    let allFilteredItems =  searchText.isEmpty ? viewModel.groupedRecipes.keys.sorted() :
    viewModel.groupedRecipes.keys.filter { category in

      viewModel.groupedRecipes[category]?.contains { recipe in
        recipe.name.localizedCaseInsensitiveContains(searchText)
      } ?? false
    }
    return allFilteredItems.filter { category in
      selectedFilters.isEmpty || selectedFilters.contains(category)
    }.sorted()
  }


  var body: some View {
    NavigationStack {
      VStack {
        // Toggle Button for Filter View
        HStack {
          Button(action: {
          
              showingFilter.toggle()

          }) {
            Image(systemName: showingFilter ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
              .imageScale(.large)
            Text("Filters")
              .font(.headline)
          }
          .buttonStyle(PlainButtonStyle())
          //           Spacer()
        }
        .padding(.horizontal)

        // Show FilterView if toggled
        if showingFilter {
          FilterView(allCategories: Array(viewModel.groupedRecipes.keys), selectedFilters: $selectedFilters, isExpanded: $showingFilter)
            .background(Color(UIColor.systemGray6))
            .transition(.move(edge: .top)) // Animates the filter view appearance
            .padding(.bottom, 8)
        }

        // Main Content List
        Group {
          if viewModel.isFetching {
            ProgressView()
          } else {
            ScrollView {
              VStack(alignment: .leading, spacing: 16) {
            ForEach(filteredCategories, id: \.self) { category in
              Section(header: Text(category)) {
                ForEach(viewModel.groupedRecipes[category] ?? []) { recipe in
                  RecipeRow(recipe: recipe)
                }
              }
              .background (
                RoundedRectangle(cornerRadius: 12)
                  .fill(Color.white)
                  .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 3)
              )
              .padding(.horizontal)

            }
          }
            .padding(.vertical)
        }
      }
    }

         .searchable(text: $searchText)
         .task { await viewModel.fetchRecipes() }
       }
       .navigationTitle("Dessert Recipes")
     }
   }
}




struct FilterView: View {
  let allCategories: [String]
  @Binding var selectedFilters: Set<String>
  @Binding var isExpanded: Bool


  var body: some View {
    VStackLayout(alignment: .leading, spacing: 16) {
      Text("Filter By Category")
        .font(.headline)
        .padding(.horizontal)

      //display filter options with checkboxes
      ForEach(allCategories, id: \.self) { category in
        HStack {
          Toggle(isOn: Binding(get: {
            selectedFilters.contains(category)
          }, set: { isSelected in
            if isSelected {
              selectedFilters.insert(category)
            } else {
              selectedFilters.remove(category)
            }
          }

      )) {
            Text(category)
              .font(.subheadline)
          }
        }

        .padding(.horizontal)

      }
      Spacer()

      //done button
      Button {
          selectedFilters = selectedFilters
          self.isExpanded = false


      } label: {
        Text("Done")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.gray)
          .cornerRadius(10)
      }
      .padding(.horizontal)
    }
    .padding(.top)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.white)
        .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 3)
    )
    .padding(.horizontal)
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

#Preview {
  ContentView()
}
