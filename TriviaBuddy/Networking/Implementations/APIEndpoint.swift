//
//  APIEndpoint.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 28/01/24.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var method: HTTPRequestMethod { get }
    var body: Data { get }
    var queryItems: [URLQueryItem]? { get }
}

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum MockEndpoint: Endpoint {
    case mockTest

    var baseURL: URL {
        guard let url = URL(string: "http://www.boredapi.com/api/") else {
            fatalError("Invalid Base URL")
        }
        return url
    }

    var path: String {
        switch self {
        case .mockTest:
            return ""
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }

    var method: HTTPRequestMethod {
        switch self {
        case .mockTest:
            return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .mockTest:
            return nil
        }
    }

    private func optionalQueryItem(name: String, value: (any Numeric)?) -> URLQueryItem? {
        guard let value = value else { return nil }
        return URLQueryItem(name: name, value: "\(value)")
    }

    private func createQueryItems(_ items: [URLQueryItem?]) -> [URLQueryItem]? {
        return items.compactMap { $0 }
    }

    var body: Data {
        return Data()
    }
}


