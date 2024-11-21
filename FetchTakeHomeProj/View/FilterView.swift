//
//  FilterView.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/20/24.
//

import SwiftUI

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

