//
//  CachedAsyncImage.swift
//  FetchTakeHomeProj
//
//  Created by sade on 11/13/24.
//

import SwiftUI

struct CachedAsyncImage: View {
  @StateObject private var loader = ImageLoader()
  let url: URL
  let placeholder: Image

    var body: some View {
      Group {
        if let image = loader.image {
          Image(uiImage: image)
            .resizable()
            .scaledToFit()
        } else  {
          placeholder
            .resizable()
            .scaledToFit()
        }
      }
      .onAppear {
        loader.loadImage(from: url)
      }
      .onDisappear {
        loader.cancel()
      }
    }
}


