//
//  ErrorManager.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 18/02/2025.
//

import Foundation

class ErrorManager {
    static func handleError(_ error: Error, completion: @escaping (String) -> Void) {
        let errorMessage: String
        
        if let nsError = error as NSError? {
            switch nsError.code {
            case 400:
                errorMessage = "Bad request"
            case 404:
                errorMessage = "Resource not found"
            case 500:
                errorMessage = "Server error"
            default:
                errorMessage = error.localizedDescription
            }
        } else {
            errorMessage = error.localizedDescription
        }
        
        completion(errorMessage)
    }
}
