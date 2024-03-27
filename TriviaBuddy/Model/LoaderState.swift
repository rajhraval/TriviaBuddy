//
//  LoaderState.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 26/03/24.
//

import Foundation

enum LoaderState {
    case idle
    case error(error: Error)
    case loading
}
