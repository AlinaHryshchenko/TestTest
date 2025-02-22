//
//  Colors.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

enum Colors: String {
    case blueColor = "BlueColor"
    case clearBlueColor = "ClearBlueColor"
    case grayColor = "GrayColor"
    case orangeColor = "OrangeColor"
    case redColor = "RedColor"
    case textBlueColor = "TextBlueColor"
    case textDarkDrayColor = "TextDarkDrayColor"
    case textGrayColor = "TextGrayColor"
    case textLightGrayColor = "TextLightGrayColor"
    case tFBorderColor = "TFBorderColor"
    case yellowColor = "YellowColor"
    case lightGrayColor = "LightGrayColor"
}

extension Color {
    init(_ color: Colors) {
        self.init(color.rawValue, bundle: nil)
    }
}
