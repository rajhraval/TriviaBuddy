//
//  QuizItem.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 24/03/24.
//

import Foundation

struct QuizItem: Codable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let answer: String
    let incorrectAnswers: [String]

    var options: [String] {
        var totalOptions = incorrectAnswers
        totalOptions.append(answer)
        return totalOptions
    }

    enum CodingKeys: String, CodingKey {
        case type, difficulty, category, question
        case answer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
