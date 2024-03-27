//
//  QuizViewModel.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import Foundation
import UIKit.UICollectionViewCompositionalLayout

enum QuizSection: Int {
    case question
    case multipleChoice
    case boolean

    var numberOfItems: Int {
        switch self {
        case .question:
            return 1
        case .multipleChoice:
            return 4
        case .boolean:
            return 2
        }
    }

    var itemWidth: NSCollectionLayoutDimension {
        switch self {
        case .question:
            return .fractionalWidth(1)
        default:
            return .fractionalWidth(0.5)
        }
    }

    var itemHeight: NSCollectionLayoutDimension {
        switch self {
        default:
            return .fractionalHeight(1)
        }
    }

    var groupWidth: NSCollectionLayoutDimension {
        switch self {
        default:
            return .fractionalWidth(1)
        }
    }

    var groupHeight: NSCollectionLayoutDimension {
        switch self {
        case .question:
            return .fractionalHeight(0.2)
        default:
            return .fractionalHeight(0.25)
        }
    }
}

final class QuizViewModel: ObservableObject {

    @Published var sections: [QuizSection] = []
    @Published var state: LoaderState = .loading
    @Published var questions: [QuizItem] = []

    private var quizService: QuizService!

    init(quizComponent: QuizComponent) {
        self.quizService = QuizService(component: quizComponent)
        sections.removeAll()
        sections.append(.question)
        if let type = quizComponent.type, type == "boolean" {
            sections.append(.boolean)
        } else {
            sections.append(.multipleChoice)
        }
        fetchCategories()
    }

    func fetchCategories() {
        Task {
            do {
                let response = try await quizService.fetchQuiz() as QuizResponse
                state = .idle
                questions = response.results
            } catch let error {
                state = .error(error: error)
                Log.error(error)
            }
        }
    }


}
