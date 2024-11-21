//
//  FilterViewWrapper.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/20/24.
//

import SwiftUI

struct FilterViewWrapper: View {
  @EnvironmentObject var viewModel: RecipeViewModel
  @Binding var selectedFilters: Set<String>
  @Binding var showingFilter: Bool
    var body: some View {
          FilterView(
              allCategories: Array(viewModel.groupedRecipes.keys),
              selectedFilters: $selectedFilters,
              isExpanded: $showingFilter
          )
          .background(Color(UIColor.systemGray6))
          .transition(.move(edge: .top))
          .padding(.bottom, 8)
      }
    }


