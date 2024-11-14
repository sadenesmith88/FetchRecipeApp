//
//  FetchTakeHomeProjApp.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/12/24.
//

import SwiftUI

@main
struct FetchTakeHomeProjApp: App {
  @StateObject private var viewModel = RecipeViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(viewModel)
        }
    }
}
