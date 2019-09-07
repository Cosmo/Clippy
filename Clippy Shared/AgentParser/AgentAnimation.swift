//
//  AgentAnimation.swift
//  Clippy
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

struct AgentAnimation {
    let animationName: String
    let transitionType: Int
    let frames: [AgentFrame]
}

extension AgentAnimation {
    static func parse(content: String) -> AgentAnimation? {
        var animationName: String?
        var transitionType: Int?
        let frameTexts = content.fetchInclusive("DefineFrame", until: "EndFrame")
        let frames = frameTexts.compactMap { AgentFrame.parse(content: $0) }
        
        content.enumerateLines(invoking: { (line: String, stop: inout Bool) in
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedLine.starts(with: "DefineAnimation ") {
                animationName = trimmedLine.stringValueOfDefinition(onKey: "DefineAnimation")?.removedQuotes()
            }
            if trimmedLine.starts(with: "TransitionType ") {
                transitionType = trimmedLine.intValueOfKeyValue(onKey: "TransitionType")
            }
        })
        
        if let animationName = animationName, let transitionType = transitionType {
            return AgentAnimation(animationName: animationName, transitionType: transitionType, frames: frames)
        }
        return nil
    }
}
