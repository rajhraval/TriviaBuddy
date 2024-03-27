//
//  CategoryService.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 24/03/24.
//

import Foundation

actor CategoryService: API {

    private let categoryCache: NSCache<NSString, CacheEntryObject> = NSCache()

    func fetchCategories() async throws -> CategoryResponse {
        if let cachedResponse = categoryCache[.categoryResponse] {
            switch cachedResponse {
            case .ready(let categoryResponse):
                return categoryResponse
            case .inProgress(let task):
                return try await task.value
            }
        }
        let task = Task<CategoryResponse, Error> {
            try await request(CategoryEndpoint.fetchCategory)
        }
        categoryCache[.categoryResponse] = .inProgress(task)
        do {
            let categoryResponse = try await task.value
            categoryCache[.categoryResponse] = .ready(categoryResponse)
            return categoryResponse
        } catch let error {
            categoryCache[.categoryResponse] = nil
            throw error
        }
    }

}
