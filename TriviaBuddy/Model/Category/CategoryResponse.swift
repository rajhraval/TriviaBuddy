//
//  CategoryResponse.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 24/03/24.
//

import Foundation

struct CategoryResponse: Codable {
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case categories = "trivia_categories"
    }
}
