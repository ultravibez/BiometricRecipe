//
//  RecipeDetailViewModel.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 14/11/2024.
//

import LocalAuthentication

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    private let encryptedData: Data?
    private let cryptoManager: CryptoHandler
    @Published var decryptedRecipe: Recipe?
    @Published var isAuthenticated = false
    @Published var authenticationFailed = false
    
    init(encryptedData: Data?,
         cryptoManager: CryptoHandler) {
        self.encryptedData = encryptedData
        self.cryptoManager = cryptoManager
    }
    
    func authenticateAndDecrypt() {
        authenticateWithBiometrics { [weak self] success in
            guard let self else { return }
            if success, let encryptedData = encryptedData {
                if let decryptedData = cryptoManager.decrypt(data: encryptedData),
                   let recipe = try? JSONDecoder().decode(Recipe.self, from: decryptedData) {
                    self.decryptedRecipe = recipe
                    self.isAuthenticated = true
                } else {
                    print("Failed to decrypt data.")
                    authenticationFailed = true
                }
            } else {
                print("Authentication failed or unavailable.")
                authenticationFailed = true
            }
        }
    }
    
    private func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to view the recipe details"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            if let error = error {
                print("Biometric authentication not available: \(error.localizedDescription)")
            } else {
                print("Biometric authentication not available for an unknown reason.")
            }
            completion(false)
        }
    }
}
