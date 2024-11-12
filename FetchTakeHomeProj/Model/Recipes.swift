//
//  Recipes.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/12/24.
//

import Foundation

struct RecipeRoot: Codable {
  var recipes: [Recipes]
}

struct Recipes: Codable {
  var cuisine: String
  var name: String
  var photo_url_large: String?
  var photo_url_small: String?
  var uuid: String
  var source_url: String?
  var youtube_url: String?

}
