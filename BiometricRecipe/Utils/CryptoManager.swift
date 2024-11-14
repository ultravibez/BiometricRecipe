//
//  CryptoManager.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 14/11/2024.
//

import CryptoKit
import Foundation

protocol CryptoHandler {
    func encrypt(data: Data) -> Data?
    func decrypt(data: Data) -> Data?
}

final class CryptoManager: CryptoHandler {
    private let encryptionKey: SymmetricKey
    
    init() {
        // In production, we will store and retrieve this key securely, such as from Keychain.
        self.encryptionKey = SymmetricKey(size: .bits256)
    }
    
    func encrypt(data: Data) -> Data? {
        do {
            let sealedBox = try AES.GCM.seal(data, using: encryptionKey)
            return sealedBox.combined
        } catch {
            print("Encryption failed:", error)
            return nil
        }
    }
    
    func decrypt(data: Data) -> Data? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)
            return decryptedData
        } catch {
            print("Decryption failed:", error)
            return nil
        }
    }
}
