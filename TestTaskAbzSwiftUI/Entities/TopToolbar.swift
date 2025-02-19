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
            .foregroundColor(.black)
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .padding(.horizontal, -20)
            .ignoresSafeArea(edges: .top)
    }
}
