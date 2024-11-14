//
//  RecipeItemView.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 13/11/2024.
//

import SwiftUI

struct RecipeItemView: View {
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
                .foregroundStyle(Color.primaryText)
            
            if let imageUrl = URL(string: recipe.thumb) {
                CachedAsyncImage(url: imageUrl)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(5)
            }
            
            VStack(alignment: .leading) {
                Text("Fats: \(recipe.fats)")
                    .font(.caption)
                    .foregroundStyle(Color.primaryText)
                Text("Calories: \(recipe.calories)")
                    .font(.caption)
                    .foregroundStyle(Color.primaryText)
                Text("Carbos: \(recipe.carbos)")
                    .font(.caption)
                    .foregroundStyle(Color.primaryText)
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.recipeItemStroke, lineWidth: 1))
        .padding()
    }
}

#Preview {
    RecipeItemView(recipe: Recipe.mockRecipe)
}

