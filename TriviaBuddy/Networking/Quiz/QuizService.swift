//
//  QuizService.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 24/03/24.
//

import Foundation

final class QuizService: API {

    private var component: QuizComponent!

    init(component: QuizComponent!) {
        self.component = component
    }

    func fetchQuiz() async throws -> QuizResponse {
        try await request(QuizEndpoint.generateQuiz(questions: component.questions, category: component.category, difficulty: component.difficulty, type: component.type))
    }

}
