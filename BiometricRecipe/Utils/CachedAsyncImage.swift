//
//  CachedAsyncImage.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 13/11/2024.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL
    @State private var image: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        if let cachedImage = ImageCache.shared.getImage(for: url) {
            self.image = cachedImage
            self.isLoading = false
        } else {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let loadedImage = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                ImageCache.shared.setImage(loadedImage, for: url)
                
                DispatchQueue.main.async {
                    self.image = loadedImage
                    self.isLoading = false
                }
            }
            .resume()
        }
    }
}
