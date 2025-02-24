//
//  UsersResponse.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 20/02/2025.
//

import Foundation

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
