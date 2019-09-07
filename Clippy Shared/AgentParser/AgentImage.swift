//
//  AgentImage.swift
//  Clippy
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

struct AgentImage {
    /// A `fileName` with value of `nil` indicates that the Agent is hidden.
    /// Used for example as the first frame of "Show" and last frame of "Hide"
    let fileName: String
}

extension AgentImage {
    static func parse(content: String) -> AgentImage? {
        var fileName: String?
        content.enumerateLines(invoking: { (line: String, stop: inout Bool) in
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedLine.starts(with: "Filename ") {
                fileName = trimmedLine.stringValueOfKeyValue(onKey: "Filename")?.removedQuotes()
            }
        })
        
        if let fileName = fileName {
            return AgentImage(fileName: fileName)
        }
        return nil
    }
}
