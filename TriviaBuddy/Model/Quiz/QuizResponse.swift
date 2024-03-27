//
//  QuizResponse.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 24/03/24.
//

import Foundation

struct QuizResponse: Codable {
    let responseCode: Int
    let results: [QuizItem]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}
