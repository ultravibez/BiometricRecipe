//
//  APIClient.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 13/11/2024.
//

import Foundation

class APIClient {
    
    func request<M: Decodable>(
        model: M.Type = M.self,
        path: String,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> M {
        guard let pathURL = URL(string: path) else {
            throw APIError.invalidRequestURL
        }
        
        let request = URLRequest(url: pathURL)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           !(200...299 ~= response.statusCode) {
            throw APIError.apiError
        }
        
        do {
            return try decoder.decode(M.self, from: data)
        } catch {
            throw APIError.decodingFailed(type: M.self,
                                          message: error.localizedDescription)
        }
    }
}

extension APIClient {
    func getRecipes() async throws -> [Recipe] {
        try await request(path: "https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json")
    }
}
