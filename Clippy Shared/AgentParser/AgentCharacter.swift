//
//  AgentCharacter.swift
//  Clippy
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

struct AgentCharacter {
    let infos: [AgentInfo]
    let guid: String
    let width: Int
    let height: Int
    let transparency: Int
    let defaultFrameDuration: Int
    let style: String
    let colorTable: String
}

extension AgentCharacter {
    static func parse(content: String) -> AgentCharacter? {
        let infoTexts = content.fetchInclusive("DefineInfo", until: "EndInfo")
        let infos = infoTexts.compactMap { AgentInfo.parse(content: $0) }
        var guid: String?
        var width: Int?
        var height: Int?
        var transparency: Int?
        var defaultFrameDuration: Int?
        var style: String?
        var colorTable: String?
        content.enumerateLines(invoking: { (line: String, stop: inout Bool) in
            let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if trimmedLine.starts(with: "GUID ") {
                guid = trimmedLine.stringValueOfKeyValue(onKey: "GUID")?.removedCurlyBraces()
            }
            if trimmedLine.starts(with: "Width ") {
                width = trimmedLine.intValueOfKeyValue(onKey: "Width")
            }
            if trimmedLine.starts(with: "Height ") {
                height = trimmedLine.intValueOfKeyValue(onKey: "Height")
            }
            if trimmedLine.starts(with: "Transparency ") {
                transparency = trimmedLine.intValueOfKeyValue(onKey: "Transparency")
            }
            if trimmedLine.starts(with: "DefaultFrameDuration ") {
                defaultFrameDuration = trimmedLine.intValueOfKeyValue(onKey: "DefaultFrameDuration")
            }
            if trimmedLine.starts(with: "Style ") {
                style = trimmedLine.stringValueOfKeyValue(onKey: "Style")
            }
            if trimmedLine.starts(with: "ColorTable ") {
                colorTable = trimmedLine.stringValueOfKeyValue(onKey: "ColorTable")?.removedQuotes()
            }
        })
        
        if let guid = guid, let width = width, let height = height, let transparency = transparency, let defaultFrameDuration = defaultFrameDuration, let style = style, let colorTable = colorTable {
            return AgentCharacter(infos: infos, guid: guid, width: width, height: height, transparency: transparency, defaultFrameDuration: defaultFrameDuration, style: style, colorTable: colorTable)
        }
        return nil
    }
}
