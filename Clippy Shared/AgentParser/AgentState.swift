//
//  AgentState.swift
//  Clippy
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

struct AgentState {
    let name: String
    let animationNames: [String]
}

extension AgentState: Extractable {
    static var scope: ParseScope {
        return ("DefineState", "EndState")
    }
    
    static func parse(content: String) -> Extractable? {
        var name: String?
        var animationNames: [String] = []
        content.enumerateLines(invoking: { (line: String, stop: inout Bool) in
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedLine.starts(with: "DefineState ") {
                name = trimmedLine.stringValueOfDefinition(onKey: "DefineState")?.removedQuotes()
            }
            if trimmedLine.starts(with: "Animation ") {
                if let animationName = trimmedLine.stringValueOfKeyValue(onKey: "Animation")?.removedQuotes() {
                    animationNames.append(animationName)
                }
            }
        })
        
        if let name = name {
            return AgentState(name: name, animationNames: animationNames)
        }
        return nil
    }
}
