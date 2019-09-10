//
//  Extractable.swift
//  Clippy
//
//  Created by Devran on 10.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

protocol Extractable {
    typealias ParseScope = (start: String, end: String)
    
    static var scope: ParseScope { get }
    static func parse(content: String) -> Extractable?
    static func extractMany(content: String) -> [Extractable]
    static func extractSingle(content: String) -> Extractable?
}

extension Extractable {
    static func extractSingle(content: String) -> Extractable? {
        guard let text = content.fetchInclusive(scope.start, until: scope.end).first else { return nil }
        return self.parse(content: text)
    }
    
    static func extractMany(content: String) -> [Extractable] {
        let texts = content.fetchInclusive(scope.start, until: scope.end)
        return texts.compactMap { self.parse(content: $0) }
    }
}

