//
//  RecipeListView.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 13/11/2024.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    private let cryptoManager: CryptoHandler
    
    init(cryptoManager: CryptoHandler) {
        self.cryptoManager = cryptoManager
    }
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(viewModel.recipes) { recipe in
                    // This might be a bit of an heavy operation(encoding and encrypting) so in
                    // a production app I would probably come up with a workaround to encrypt it
                    // on demand(only when the user clicks the recipe)
                    if let recipeData = try? JSONEncoder().encode(recipe),
                       let encryptedData = cryptoManager.encrypt(data: recipeData) {
                        NavigationLink(destination: RecipeDetailView(encryptedData: encryptedData, cryptoManager: cryptoManager)) {
                            RecipeItemView(recipe: recipe)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onAppear {
            Task {
                await viewModel.getRecipes()
            }
        }
    }
}

#Preview {
    RecipeListView(cryptoManager: CryptoManager())
}
