//
//  ImageCache.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/13/24.
//

import Foundation
import SwiftUI

class ImageCache {
  static let shared = ImageCache()
  private init() {}

  private let cache = NSCache<NSURL, UIImage>()

  func image(for url: URL) -> UIImage? {
    return cache.object(forKey: url as NSURL)
  }

  func save(_ image: UIImage, for url: URL) {
    cache.setObject(image, forKey: url as NSURL)
  }
}
