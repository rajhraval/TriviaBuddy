//
//  QuizComponents.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import Foundation

struct QuizComponent {
    let questions: Int
    let category: Int?
    let difficulty: String?
    let type: String?

    init(questions: Int, category: Int? = nil, difficulty: String? = nil, type: String? = nil) {
        self.questions = questions
        self.category = category
        self.difficulty = difficulty
        self.type = type
    }
}

enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case difficult

    var display: String {
        return rawValue.capitalized
    }

    var value: String {
        rawValue
    }
}

enum CategoryType: String, CaseIterable {
    case multipleChoice
    case boolean

    var display: String {
        switch self {
        case .multipleChoice:
            return "Multiple Choice"
        case .boolean:
            return "True or False"
        }
    }

    var rawValue: String {
        switch self {
        case .multipleChoice:
            return "multiple"
        case .boolean:
            return "boolean"
        }
    }
}

enum Questions: Int, CaseIterable {
    case typeOne
    case typeTwo
    case typeThree
    case typeFour

    var rawValue: Int {
        switch self {
        case .typeOne:
            return 10
        case .typeTwo:
            return 15
        case .typeThree:
            return 20
        case .typeFour:
            return 25
        }
    }
}
