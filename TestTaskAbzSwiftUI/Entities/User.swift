//
//  User.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import UIKit
import SwiftUI

struct User: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let photo: String
}

struct UsersResponse: Decodable {
    let success: Bool
    let users: [User]
  //  let totalCount: Int 

}


enum TypePosition: String, CaseIterable, Identifiable, Equatable {
    case frontend = "Frontend developer"
    case backend = "Backend developer"
    case designer = "Designer"
    case qa = "QA"
    
    var id: Int {
        switch self {
        case .frontend: return 1
        case .backend: return 2
        case .designer: return 3
        case .qa: return 4
        }
    }
}


enum RegistrationError: Error {
    case invalidPhoto
    case uploadFailed
    case registrationFailed
}
