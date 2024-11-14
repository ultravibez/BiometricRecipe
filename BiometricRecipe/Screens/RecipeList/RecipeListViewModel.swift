//
//  RecipeListView.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 13/11/2024.
//

import Foundation

@MainActor
final class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    private let apiClient = APIClient()
    
    func getRecipes() async {
        do {
            let result = try await apiClient.getRecipes()
            recipes = result
        } catch let error as APIError {
            print(error.description)
        } catch {
            print(error.localizedDescription)
        }
    }
}
