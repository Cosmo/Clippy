//
//  AgentBranching.swift
//  Clippy
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

struct AgentBranching {
    let branchTo: Int
    let probability: Int
}

extension AgentBranching {
    static func parse(content: String) -> [AgentBranching] {
        var branchings: [AgentBranching] = []
        
        var branchToBuffer: Int?
        var probabilityBuffer: Int?
        
        content.enumerateLines(invoking: { (line: String, stop: inout Bool) in
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedLine.starts(with: "BranchTo ") {
                branchToBuffer = trimmedLine.intValueOfKeyValue(onKey: "BranchTo")
            }
            if trimmedLine.starts(with: "Probability ") {
                probabilityBuffer = trimmedLine.intValueOfKeyValue(onKey: "Probability")
            }
            if let branchTo = branchToBuffer, let probability = probabilityBuffer {
                let branching = AgentBranching(branchTo: branchTo, probability: probability)
                branchings.append(branching)
                branchToBuffer = nil
                probabilityBuffer = nil
            }
        })
        
        return branchings
    }
}
