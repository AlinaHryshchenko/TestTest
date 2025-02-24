//
//  CustomTextField.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 23/02/2025.
//

import Foundation
import SwiftUI

// A custom text field with validation for name, email, and phone number.
struct CustomTextField: View {
    @Binding var text: String
    
    var placeholder: String
    var isEmail: Bool = false
    var isPhone: Bool = false
   
    // MARK: - Validation
    // Checks if the input is valid based on the type (name, email, or phone).
    var isValid: Bool {
        if text.isEmpty { return true }
        if isEmail {
            return ValidatorManager.isValidEmail(text)
        } else if isPhone {
            return ValidatorManager.isValidPhone(text)
        } else {
            return ValidatorManager.isValidName(text)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField(placeholder, text: $text)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(isValid
                                                                  ? Color(Colors.tFBorderColor)
                                                                  : Color(Colors.redColor),
                                                                  lineWidth: 1))
                .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
            // Show phone number placeholder if the field is for phone input and is valid or empty
            if isPhone && (text.isEmpty || isValid) {
                Text("+38 (XXX) XXX - XX - XX")
                    .foregroundColor(Color(Colors.textGrayColor))
                    .font(.custom(NutinoSansFont.light.rawValue, size: 12))
                    .padding(.leading, 15)
                    .padding(.top, 3)
            }
            
            // Show error message if the input is invalid
            Text(isEmail ? "Invalid email format" : isPhone ? "Required field" : "Required field")
                .foregroundColor(Color(Colors.redColor))
                .font(.custom(NutinoSansFont.light.rawValue, size: 12))
                .padding(.leading, 15)
                .padding(.top, 3)
                .opacity(isValid ? 0 : 1)
        }
    }
}
