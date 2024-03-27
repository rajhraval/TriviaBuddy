//
//  QuizEndpoint.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 24/03/24.
//

import Foundation

enum QuizEndpoint: Endpoint {
    case generateQuiz(questions: Int, category: Int?, difficulty: String?, type: String?)

    var baseURL: URL {
        guard let url = URL(string: "https://opentdb.com/") else { fatalError("Base URL is incorrect") }
        return url
    }

    var path: String {
        return "api.php"
    }

    var headers: [String : String]? {
        return nil
    }

    var method: HTTPRequestMethod {
        return .get
    }

    var body: Data {
        return Data()
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .generateQuiz(let questions, let category, let difficulty, let type):
            let queryItems: [URLQueryItem?] = [
                optionalQueryItem(name: "amount", value: questions),
                optionalQueryItem(name: "category", value: category),
                URLQueryItem(name: "difficulty", value: difficulty),
                URLQueryItem(name: "type", value: type)
            ]
            return createQueryItems(queryItems)
        }
    }

    private func optionalQueryItem(name: String, value: (any Numeric)?) -> URLQueryItem? {
        guard let value = value else { return nil }
        return URLQueryItem(name: name, value: "\(value)")
    }

    private func createQueryItems(_ items: [URLQueryItem?]) -> [URLQueryItem]? {
        return items.compactMap { $0 }
    }


}
