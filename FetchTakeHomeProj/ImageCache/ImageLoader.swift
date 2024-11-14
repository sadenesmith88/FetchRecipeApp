//
//  ImageLoader.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/13/24.
//

import Foundation
import Combine
import UIKit

class ImageLoader: ObservableObject {
  @Published var image: UIImage?
  private var cancellable: AnyCancellable?

  func loadImage(from url: URL) {
    if let cachedImage = ImageCache.shared.image(for: url) {
      self.image = cachedImage
      return
    }

    //download image if not cached
    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .map { UIImage(data: $0.data) }
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] downloadedImage in
        guard let downloadedImage = downloadedImage else { return }
        ImageCache.shared.save(downloadedImage, for: url)
        self?.image = downloadedImage
      }
  }

  func cancel() {
    cancellable?.cancel()
  }
}
