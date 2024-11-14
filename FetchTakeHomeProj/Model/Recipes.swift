//
//  Recipes.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/12/24.
//

import Foundation

struct RecipeRoot: Codable {
  let recipes: [Recipe]
}

struct Recipe: Identifiable, Codable {
  let cuisine: String
  let name: String
  let photo_url_large: String?
  let photo_url_small: String?
  let uuid: String
  let source_url: String?
  let youtube_url: String?

  var id: String { uuid }

  var dessertType: String {
    let _ = self.name.lowercased()
    var dessertType: String {
      let name = self.name.lowercased()
      let types: [(String, [String])] = [
        ("Cakes", ["cake"]),
        ("Pies & Tarts", ["pie", "tart"]),
        ("Puddings", ["pudding"]),
        ("Cookies & Pastries", ["cookie", "biscuit", "croissant", "donut", "balik"]),
        ("Chocolate Desserts", ["chocolate", "brownie", "fudge"]),
        ("Fruit Desserts", ["apple", "berry", "peach", "rhubarb"]),
        ("Traditional", ["christmas", "spotted dick", "treacle"])
      ]

      return types.first { type in
        type.1.contains { name.contains($0) }
      }?.0 ?? "Other Desserts"
    }
    return dessertType
  }
}

struct RecipeDetails: Codable {
  let ingredients: [String]
  let instructions: String
}


