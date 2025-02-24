//
//  ErrorText.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 23/02/2025.
//

import Foundation
import SwiftUI

struct ErrorText: View {
    var message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(Color(Colors.redColor))
            .font(.custom(NutinoSansFont.light.rawValue, size: 12))
            .padding(.leading, 5)
    }
}
