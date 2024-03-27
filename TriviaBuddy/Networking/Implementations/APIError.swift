//
//  APIError.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 28/01/24.
//

import Foundation

enum APIError: Error {
    case invalidURLError
    case networkingError(error: Error)
    case decodingError(error: Error)
}
