//
//  RecipeDetailView.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 14/11/2024.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject private var viewModel: RecipeDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(encryptedData: Data?, cryptoManager: CryptoHandler) {
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(encryptedData: encryptedData, cryptoManager: cryptoManager))
    }
    
    var body: some View {
        ZStack {
            // Content display
            VStack {
                if viewModel.isAuthenticated, let decryptedRecipe = viewModel.decryptedRecipe {
                    VStack {
                        Text(decryptedRecipe.name)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                            .foregroundStyle(Color.primaryText)
                        
                        if let imageUrl = URL(string: decryptedRecipe.image) {
                            CachedAsyncImage(url: imageUrl)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .cornerRadius(5)
                        }
                    }
                    
                    VStack(alignment: .center) {
                        Text("Fats: \(decryptedRecipe.fats)")
                            .font(.caption)
                            .foregroundStyle(Color.primaryText)
                        Text("Calories: \(decryptedRecipe.calories)")
                            .font(.caption)
                            .foregroundStyle(Color.primaryText)
                        Text("Carbos: \(decryptedRecipe.carbos)")
                            .font(.caption)
                            .foregroundStyle(Color.primaryText)
                        Text("Description: \(decryptedRecipe.description)")
                            .font(.caption)
                            .foregroundStyle(Color.primaryText)
                    }
                    .padding()
                    
                    Spacer()
                } else if viewModel.authenticationFailed {
                    Text("Authentication Failed")
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                } else {
                    ProgressView("Authenticating...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
            .overlay {
                if !viewModel.isAuthenticated && !viewModel.authenticationFailed {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 10)
                }
            }
        }
        .navigationTitle("Recipe Details")
        .onAppear {
            viewModel.authenticateAndDecrypt()
        }
    }
}
