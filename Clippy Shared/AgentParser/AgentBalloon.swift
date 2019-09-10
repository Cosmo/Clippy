//
//  AgentBalloon.swift
//  Clippy
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

struct AgentBalloon {
    let numberOfLines: Int
    let charactersPerLine: Int
    let fontName: String
    let fontHeight: Int
    let foregroundColor: String
    let backgroundColor: String
    let borderColor: String
}

extension AgentBalloon: Extractable {
    static var scope: ParseScope {
        return ("DefineBalloon", "EndBalloon")
    }
    
    static func parse(content: String) -> Extractable? {
        var numberOfLines: Int?
        var charactersPerLine: Int?
        var fontName: String?
        var fontHeight: Int?
        var foregroundColor: String?
        var backgroundColor: String?
        var borderColor: String?
        
        content.enumerateLines(invoking: { (line: String, stop: inout Bool) in
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedLine.starts(with: "NumLines ") {
                numberOfLines = trimmedLine.intValueOfKeyValue(onKey: "NumLines")
            }
            if trimmedLine.starts(with: "CharsPerLine ") {
                charactersPerLine = trimmedLine.intValueOfKeyValue(onKey: "CharsPerLine")
            }
            if trimmedLine.starts(with: "FontName ") {
                fontName = trimmedLine.stringValueOfKeyValue(onKey: "FontName")?.removedQuotes()
            }
            if trimmedLine.starts(with: "FontHeight ") {
                fontHeight = trimmedLine.intValueOfKeyValue(onKey: "FontHeight")
            }
            if trimmedLine.starts(with: "ForeColor ") {
                foregroundColor = trimmedLine.stringValueOfKeyValue(onKey: "ForeColor")
            }
            if trimmedLine.starts(with: "BackColor ") {
                backgroundColor = trimmedLine.stringValueOfKeyValue(onKey: "BackColor")
            }
            if trimmedLine.starts(with: "BorderColor ") {
                borderColor = trimmedLine.stringValueOfKeyValue(onKey: "BorderColor")
            }
        })
        
        if let numberOfLines = numberOfLines, let charactersPerLine = charactersPerLine, let fontName = fontName, let fontHeight = fontHeight, let foregroundColor = foregroundColor, let backgroundColor = backgroundColor, let borderColor = borderColor {
            return AgentBalloon(numberOfLines: numberOfLines, charactersPerLine: charactersPerLine, fontName: fontName, fontHeight: fontHeight, foregroundColor: foregroundColor, backgroundColor: backgroundColor, borderColor: borderColor)
        }
        return nil
    }
}
