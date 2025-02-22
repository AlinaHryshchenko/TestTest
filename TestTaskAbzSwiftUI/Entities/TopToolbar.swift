//
//  TopToolbar.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

struct TopToolbar: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.custom(NutinoSansFont.regular.rawValue, size: 20))
            .frame(height: 56)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .background(Color(Colors.yellowColor))
            .padding(.vertical, 1)
    }
}
