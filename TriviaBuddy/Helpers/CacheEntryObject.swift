//
//  CacheEntryObject.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import Foundation

enum CacheEntry {
    case inProgress(Task<CategoryResponse, Error>)
    case ready(CategoryResponse)
}

final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) { self.entry = entry }
}
