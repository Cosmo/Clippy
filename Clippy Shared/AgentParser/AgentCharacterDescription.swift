//
//  AgentCharacterDescription.swift
//  Clippy iOS
//
//  Created by Devran on 06.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation
import SpriteKit

struct AgentCharacterDescription {
    var character: AgentCharacter
    var balloon: AgentBalloon
    var animations: [AgentAnimation]
    var states: [AgentState]
    
    var basePath: URL
    var resourceName: String
    var spriteMap: SKTexture
    
    init?(baseURL: URL) {
        self.basePath = baseURL
        self.resourceName = baseURL.lastPathComponent
        
        let fileURL = basePath.appendingPathComponent("\(resourceName).acd")
        
        guard let fileContent = try? String(contentsOf: fileURL, encoding: String.Encoding.utf8) else { return nil }
        
        // Character
        guard let characterText = fileContent.fetchInclusive("DefineCharacter", until: "EndCharacter").first else { return nil }
        let character = AgentCharacter.parse(content: characterText)
        
        // Balloon
        guard let balloonText = fileContent.fetchInclusive("DefineBalloon", until: "EndBalloon").first else { return nil }
        let balloon = AgentBalloon.parse(content: balloonText)
        
        // Animations
        let animationTexts = fileContent.fetchInclusive("DefineAnimation", until: "EndAnimation")
        let animations = animationTexts.compactMap { AgentAnimation.parse(content: $0) }
        
        // States
        let stateTexts = fileContent.fetchInclusive("DefineState", until: "EndState")
        let states = stateTexts.compactMap { AgentState.parse(content: $0) }
        
        // Sprite Map
        let imageURL = URL(fileURLWithPath: "/Users/Devran/Agents/\(resourceName)/\(resourceName)_sprite_map.png")
        spriteMap = SKTexture(image: NSImage(contentsOf: imageURL)!)
        
        if let character = character, let balloon = balloon {
            self.character = character
            self.balloon = balloon
            self.animations = animations
            self.states = states
        } else {
            return nil
        }
    }
    
    func findAnimation(_ name: String) -> AgentAnimation? {
        return animations.first(where: { $0.name == name })
    }
}

extension AgentCharacterDescription {
    static func agentsURL() -> URL {
        let fileManager = FileManager.default
        var homeDirectory = fileManager.homeDirectoryForCurrentUser
        homeDirectory.appendPathComponent("Agents")
        return homeDirectory
    }
    
    static func availableAgents() -> [String] {
        var assistants: [String] = []
        let items = try! FileManager.default.contentsOfDirectory(at: agentsURL(), includingPropertiesForKeys: nil, options: [])
        for item in items {
            if item.hasDirectoryPath {
                assistants.append(item.lastPathComponent)
            }
        }
        return assistants
    }
    
    static func loadAgent(resourceName: String) -> AgentCharacterDescription? {
        AgentCharacterDescription(baseURL: agentsURL().appendingPathComponent(resourceName))
    }
}

enum AgentError: Error {
    case frameOutOfBounds
}

extension AgentCharacterDescription {
    var columns: Int {
        let columns = Int(spriteMap.size().width) / character.width
        return columns
    }
    var rows: Int {
        let rows = Int(spriteMap.size().height) / character.height
        return rows
    }
    
    func textureAtPosition(x: Int, y: Int) throws -> SKTexture {
        guard (0...rows ~= y && 0...columns ~= x) else { throw AgentError.frameOutOfBounds }
        
        let unitWidth = CGFloat(character.width) / spriteMap.size().width
        let unitHeight = CGFloat(character.height) / spriteMap.size().height
        
        let rectX = CGFloat(x) * unitWidth
        let rectY = CGFloat((rows - 1) - y) * unitHeight
        
        let textureRect = CGRect(x: rectX, y: rectY, width: unitWidth, height: unitHeight)
        let texture = SKTexture(rect: textureRect, in: spriteMap)
        texture.filteringMode = .nearest
        return texture
    }
    
    func textureAtIndex(index: Int) throws -> SKTexture {
        let x = index % columns
        let y = index / columns
        return try! textureAtPosition(x: x, y: y)
    }
}
