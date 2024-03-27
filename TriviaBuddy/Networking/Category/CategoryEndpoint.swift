//
//  CategoryEndpoint.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 24/03/24.
//

import Foundation

enum CategoryEndpoint: Endpoint {
    case fetchCategory

    var baseURL: URL {
        guard let url = URL(string: "https://opentdb.com/") else { fatalError("Base URL is incorrect") }
        return url
    }

    var path: String {
        switch self {
        case .fetchCategory:
            return "api_category.php"
        }
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
        return nil
    }
}
