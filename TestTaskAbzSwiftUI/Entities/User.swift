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
    var registration_timestamp: Date
}

extension User: Comparable {
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.registration_timestamp < rhs.registration_timestamp
    }
}
