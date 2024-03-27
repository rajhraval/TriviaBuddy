//
//  String+.swift
//  TriviaBuddy
//
//  Created by Raj Raval on 27/03/24.
//

import Foundation

extension String {
    var showPlainString: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return self }

        return attributedString.string
    }
}
