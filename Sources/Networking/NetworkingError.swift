//
//  NetworkingError.swift
//  
//
//  Created by Ruben Dario Garcia Astudillo on 27/04/23.
//

import Foundation

public enum NetworkingError: Error, Equatable {
    case badURL
    case networkError(Error)
    case badResponse
    case decodingError(Error)
    
    public static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL):
            return true
        case let (.networkError(lhsError), .networkError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.badResponse, .badResponse):
            return true
            
            
        case let (.decodingError(lhsError), .decodingError(rhsError)):
            
            return lhsError.localizedDescription == rhsError.localizedDescription
            
            
            
        default:
            return false
        }
    }
}
