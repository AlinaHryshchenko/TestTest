//
//  TypePosition.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 20/02/2025.
//

import Foundation

//enum TypePosition: String, CaseIterable, Identifiable, Equatable {
//    case frontend = "Frontend developer"
//    case backend = "Backend developer"
//    case designer = "Designer"
//    case qa = "QA"
//    
//    var id: Int {
//        switch self {
//        case .frontend: return 1
//        case .backend: return 2
//        case .designer: return 3
//        case .qa: return 4
//        }
//    }
//}

struct Position: Decodable, Identifiable, Equatable {
    var id: Int
    var name: String
}

struct PositionsResponse: Decodable {
    let success: Bool
    let positions: [Position]
}
