//
//  HomeViewModel.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 24/03/24.
//

import Foundation
import UIKit.UICollectionViewCompositionalLayout

enum HomeSection: Int, CaseIterable, HeaderSection {
    case questions
    case category
    case difficulty
    case type

    var title: String {
        switch self {
        case .questions:
            return "Number of Questions"
        case .category:
            return "Category"
        case .difficulty:
            return "Difficulty"
        case .type:
            return "Answer Type"
        }
    }

    var numberOfItems: Int {
        switch self {
        case .questions:
            return 4
        case .category:
            return 1
        case .difficulty:
            return 3
        case .type:
            return 2
        }
    }

    var itemWidth: NSCollectionLayoutDimension {
        switch self {
        case .questions:
            return .fractionalWidth(1/4)
        case .category:
            return .fractionalWidth(1)
        case .difficulty:
            return .fractionalWidth(1/3)
        case .type:
            return .fractionalWidth(1/2)
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
        default:
            return .estimated(48)
        }
    }
}

final class HomeViewModel: ObservableObject {

    @Published var state: LoaderState = .loading
    @Published var sections: [HomeSection] = HomeSection.allCases
    @Published var categories: [Category] = []

    @Published var selectedDifficulty: String = "easy"
    @Published var selectedAnswerType: String = "multiple"
    @Published var selectedQuestions: Int = 10

    private var categoryService: CategoryService!

    init(categoryService: CategoryService = CategoryService()) {
        self.categoryService = categoryService
        fetchCategories()
    }

    func resetValues() {
        selectedDifficulty = "easy"
        selectedAnswerType = "multiple"
        selectedQuestions = 10
    }

    func fetchCategories() {
        Task {
            do {
                let response = try await categoryService.fetchCategories() as CategoryResponse
                state = .idle
                categories = response.categories
            } catch let error {
                state = .error(error: error)
                Log.error(error)
            }
        }
    }
    

}
