//
//  HeaderView.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/20/24.
//

import SwiftUI

struct HeaderView: View {
  @Binding var showingFilter: Bool
  let scrollProxy: ScrollViewProxy
    var body: some View {
          HStack {
              Button(action: { showingFilter.toggle() }) {
                  HStack {
                      Image(systemName: showingFilter ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
                          .imageScale(.large)
                      Text("Filters")
                          .font(.headline)
                  }
              }
              .buttonStyle(PlainButtonStyle())

              Spacer()

              Button {
                  scrollProxy.scrollTo("savedRecipes", anchor: .top)
              } label: {
                  Text("Saved Recipes")
                      .font(.headline)
              }
              .buttonStyle(PlainButtonStyle())
          }
          .padding(.horizontal)
      }
    }



