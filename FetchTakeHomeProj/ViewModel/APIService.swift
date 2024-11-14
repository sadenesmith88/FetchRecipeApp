//
//  ApiService.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/12/24.
//

import Foundation

class APIService {

  //create a singleton that can be used throughout the app
  static let shared = APIService()
  private let spoonacularKey = "cd1fe6cbc29b43458c4782d7dff0b02d"

  //make sure apiservice instance is not declared in any other class
  private init() {
    print("APIService initialized")

  }

  //func retrieves info from the api url
  func getInfo() async throws -> [Recipe] {
    print("getInfo() called in API service")
    guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
      print("Invalid URL")
      throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    let response = try JSONDecoder().decode(RecipeRoot.self, from: data)

    return response.recipes
  }


    
    
    
    func fetchRecipeDetails(from sourceURL: String) async throws -> RecipeDetails {
      
      let baseURL = "https://api.spoonacular.com/recipes/extract"
      var components = URLComponents(string: baseURL)!
      components.queryItems = [
        URLQueryItem(name: "url", value: sourceURL),
        URLQueryItem(name: "apiKey", value: spoonacularKey)
      ]
      guard let url = components.url else {
        throw URLError(.badURL)
      }
      
      
      
      let (data, _) = try await URLSession.shared.data(from: url)
      
      let response = try JSONDecoder().decode(SpoonacularRecipeResponse.self, from: data)
      
      return RecipeDetails(
        ingredients: response.extendedIngredients.map { $0.original },
        instructions: response.instructions ?? "No Instrucitons Available"
        
      )
    }
  }

  //spoonacular recipe response struct
  struct SpoonacularRecipeResponse: Codable {
    let extendedIngredients: [Ingredient]
    let instructions:String?

    struct Ingredient: Codable {
      let original: String
    }
  }

