//
//  APIError.swift
//  BiometricRecipe
//
//  Created by Matan Dahan on 13/11/2024.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case invalidRequestURL
    case apiError
    case decodingFailed(type: Decodable.Type, message: String)
    
    var description: String {
        switch self {
        case .invalidRequestURL:
            return "Failed constructing URL from path"
        case .apiError:
            return "API Error"
        case .decodingFailed(let type, let message):
            return "Failed decoding \(type): \(message)"
        }
    }
}

