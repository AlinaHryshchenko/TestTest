//
//  ValidatorManager.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation

struct ValidatorManager {
    var name: String
    var email: String
    var phone: String
    
    static func isValidName(_ name: String) -> Bool {
        return name.count >= 2 && name.count <= 10
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        guard let regex = try? NSRegularExpression(pattern: emailRegex, options: .caseInsensitive) else {
            return false
        }
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
    
    static func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = #"^[\+]?380([0-9]{9})$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    static func isValid(name: String, email: String, phone: String) -> Bool {
        return ValidatorManager.isValidName(name) &&
        ValidatorManager.isValidEmail(email) &&
        ValidatorManager.isValidPhone(phone)
    }
}
