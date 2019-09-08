//
//  AgentFrame.swift
//  Clippy
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

struct AgentFrame {
    let duration: Int
    let soundEffect: String?
    let exitBranch: Int?
    let branchings: [AgentBranching]
    
    
    /// A set of images.
    ///
    /// A frame can be composed of multiple images.
    /// Example:
    /// Image 1: Contains the body as the base image
    /// Image 2: Contains a moving part — like the mouth or a hand.
    ///
    let images: [AgentImage]
    
    var durationInSeconds: Double {
        return Double(duration) / 100
    }
}

extension AgentFrame {
    static func parse(content: String) -> AgentFrame? {
        var branchings: [AgentBranching] = []
        if let branchingText = content.fetchInclusive("DefineBranching", until: "EndBranching").first {
            branchings = AgentBranching.parse(content: branchingText)
        }
        
        let imageTexts = content.fetchInclusive("DefineImage", until: "EndImage")
        let images = imageTexts.compactMap { AgentImage.parse(content: $0) }
        
        var duration: Int?
        var exitBranch: Int?
        var soundEffect: String?
        
        content.enumerateLines(invoking: { (line: String, stop: inout Bool) in
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedLine.starts(with: "Duration ") {
                duration = trimmedLine.intValueOfKeyValue(onKey: "Duration")
            }
            if trimmedLine.starts(with: "ExitBranch ") {
                exitBranch = trimmedLine.intValueOfKeyValue(onKey: "ExitBranch")
            }
            if trimmedLine.starts(with: "SoundEffect ") {
                soundEffect = trimmedLine.stringValueOfKeyValue(onKey: "SoundEffect")?.removedQuotes()
            }
        })
        
        if let duration = duration {
            return AgentFrame(duration: duration, soundEffect: soundEffect, exitBranch: exitBranch, branchings: branchings, images: images)
        }
        return nil
    }
}

extension AgentFrame {
    var soundNumber: Int? {
        guard let soundEffect = soundEffect else { return nil }
        let cleanName = soundEffect.replacingOccurrences(of: "Audio\\", with: "").replacingOccurrences(of: ".wav", with: "")
        return Int(cleanName) ?? nil
    }
}
