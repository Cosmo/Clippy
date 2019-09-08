//
//  StringExtensions.swift
//  Clippy
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

extension String {
    func stringValueOfDefinition(onKey: String) -> String? {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pairArray = trimmedString.components(separatedBy: " ")
        return pairArray.last
    }
    
    func stringValueOfKeyValue(onKey: String) -> String? {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pairArray = trimmedString.components(separatedBy: " = ")
        return pairArray.last
    }
    
    func intValueOfKeyValue(onKey: String) -> Int? {
        if let string = self.stringValueOfKeyValue(onKey: onKey) {
            return Int(string)
        }
        return nil
    }
    
    func removedQuotes() -> String? {
        var trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString.count >= 2 {
            trimmedString.removeFirst()
            trimmedString.removeLast()
        }
        return trimmedString
    }
    
    func removedCurlyBraces() -> String? {
        var trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString.count >= 2 {
            trimmedString.removeFirst()
            trimmedString.removeLast()
        }
        return trimmedString
    }
    
    func fetchInclusive(_ from: String, until: String) -> [String] {
        var elements: [String] = []
        var lastElement = ""
        var isAppending = false
        self.enumerateLines(invoking: { (line: String, stop: inout Bool) in
            if line.contains(from) {
                isAppending = true
            }
            if isAppending {
                lastElement.append("\(line)\n")
            }
            if line.contains(until) {
                isAppending = false
                elements.append(lastElement)
                lastElement = ""
            }
        })
        return elements
    }
}
