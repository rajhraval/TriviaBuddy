//
//  NSCache+.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import Foundation

enum CacheKey: String {
    case categoryResponse
}

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {

    subscript(_ cacheKey: CacheKey) -> CacheEntry? {
        get {
            let key = cacheKey.rawValue as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = cacheKey.rawValue as NSString
            if let entry = newValue {
                let value = CacheEntryObject(entry: entry)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }

}
