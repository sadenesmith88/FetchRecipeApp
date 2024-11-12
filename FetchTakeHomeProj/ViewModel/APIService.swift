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

  //make sure apiservice instance is not declared in any other class
  private init() {
    print("APIService initialized")

  }

  //func retrieves info from the api url
  func getInfo() async throws -> [Recipes] {
    print("getInfo() called in API service")
    guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
      print("Invalid URL")
      throw URLError(.badURL)
    }

    do {

      let (data, _) = try await URLSession.shared.data(from: url)

      if let dataString = String(data: data, encoding: .utf8) {
        print("Fetched JSON data: \(dataString)")
      }

      let decodedRoot = try JSONDecoder().decode(RecipeRoot.self, from: data)
      print("decoded recipes successfully")
      return decodedRoot.recipes
    } catch let decodingError as DecodingError {

      switch decodingError {
      case .typeMismatch(let type, let context):
        print("Type mismatch error: \(type) - \(context.debugDescription) - \(context.codingPath)")
      case .valueNotFound(let type, let context):
        print("Value not found error: \(type) - \(context.debugDescription) - \(context.codingPath)")
      case .keyNotFound(let key, let context):
        print("Key '\(key)' not found - \(context.debugDescription) - \(context.codingPath)")
      case .dataCorrupted(let context):
        print("Data corrupted - \(context.debugDescription)")
      default:
        print("Unknown decoding error: \(decodingError.localizedDescription)")
      }
      throw decodingError
    } catch {
      print("Error fetching data: \(error.localizedDescription)")
      throw error
    }
  }
}
