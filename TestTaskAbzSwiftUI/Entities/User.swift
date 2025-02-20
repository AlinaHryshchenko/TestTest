//
//  User.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import UIKit
import SwiftUI

//struct User: Identifiable, Decodable, Equatable {
//    let id: Int
//    let name: String
//    let email: String
//    let phone: String
//    let position: String
//    let photo: String
//}
//
//struct UsersResponse: Decodable {
//    let success: Bool
//    let users: [User]
//    let page: Int
//    let total_pages: Int
//    let total_users: Int
//    let count: Int
//
//}
//
//
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


struct User: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let photo: String
    //let registrationTimestamp: Int // Добавим поле для timestamp
    var registration_timestamp: Date

    // Создадим вычисляемое свойство для преобразования timestamp в Date
//    var registrationDate: Date {
//        return Date(timeIntervalSince1970: TimeInterval(registrationTimestamp))
//    }
}

struct UsersResponse: Decodable {
    let success: Bool
    let users: [User]
    let page: Int
    let total_pages: Int
    let total_users: Int
    let count: Int
    let links: Links
    
    struct Links: Decodable {
        let next_url: String?
        let prev_url: String?
    }
}

extension User: Comparable {
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.registration_timestamp < rhs.registration_timestamp
    }
}
