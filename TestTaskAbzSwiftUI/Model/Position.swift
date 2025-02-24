//
//  TypePosition.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 20/02/2025.
//

import Foundation

struct Position: Decodable, Identifiable, Equatable {
    var id: Int
    var name: String
}

struct PositionsResponse: Decodable {
    let success: Bool
    let positions: [Position]
}
