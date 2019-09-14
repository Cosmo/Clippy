//
//  AgentCharacterDescription.swift
//  Clippy
//
//  Created by Devran on 06.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation
import SpriteKit

enum AgentError: Error {
    case frameOutOfBounds
    case invalidFrameForCrop
}

struct Agent {
    var character: AgentCharacter
    var balloon: AgentBalloon
    var animations: [AgentAnimation]
    var states: [AgentState]
    
    var agentURL: URL
    var resourceName: String
    var resourceNameWithSuffix: String
    var spriteMap: CGImage
    let soundsURL: URL
    
    init?(agentURL: URL) {
        self.agentURL = agentURL
        self.soundsURL = agentURL.appendingPathComponent("sounds")
        self.resourceNameWithSuffix = agentURL.lastPathComponent
        self.resourceName = resourceNameWithSuffix.replacingOccurrences(of: ".agent", with: "")
        
        let fileURL = agentURL.appendingPathComponent("\(resourceName).acd")
        let imageURL = agentURL.appendingPathComponent("\(resourceName)_sprite_map.png")
        
        guard let fileContent = try? String(contentsOf: fileURL, encoding: String.Encoding.utf8) else { return nil }
        
        let character = AgentCharacter.extractSingle(content: fileContent)
        let balloon = AgentBalloon.extractSingle(content: fileContent)
        
        let animations = AgentAnimation.extractMany(content: fileContent)
        let states = AgentState.extractMany(content: fileContent)
        
        // Sprite Map
        guard let image = Agent.cgImage(contentsOf: imageURL) else { return nil }
        spriteMap = image
        
        if let character = character as? AgentCharacter, let balloon = balloon as? AgentBalloon {
            self.character = character
            self.balloon = balloon
            self.animations = (animations as? [AgentAnimation]) ?? []
            self.states = (states as? [AgentState]) ?? []
        } else {
            return nil
        }
    }
    
    static func cgImage(contentsOf contents: URL) -> CGImage? {
        #if os(OSX)
        return NSImage(contentsOf: contents)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
        #elseif os(iOS)
        return try? UIImage(data: Data(contentsOf: contents))?.cgImage
        #else
        return nil
        #endif
    }
    
    init?(resourceName: String) {
        let directoryName = "\(resourceName).agent"
        self.init(agentURL: Agent.agentsURL().appendingPathComponent(directoryName))
    }
    
    func soundURL(forIndex index: Int) -> URL {
        let fileName = "\(resourceName)_\(index).mp3"
        return soundsURL.appendingPathComponent(fileName)
    }
    
    func findAnimation(_ name: String) -> AgentAnimation? {
        return animations.first(where: { $0.name == name })
    }
}

extension Agent {
    func imageForFrame(_ frame: AgentFrame) -> CGImage? {
        var imageIndices = frame.images.reversed().compactMap{ $0.imageNumber }
        if imageIndices.isEmpty {
            imageIndices = [0]
        }
        let cgImages = imageIndices.compactMap{ spriteMap.imageAt(index: $0, size: CGSize(width: character.width, height: character.height)) }
        return CGImage.mergeImages(cgImages)
    }
}

extension Agent {
    static func agentsURL() -> URL {
        let fileManager = FileManager.default
        
        guard let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            fatalError("Cant create Agents directory")
        }
        
        let agentsURL = applicationSupportURL.appendingPathComponent("Clippy/Agents", isDirectory: true)
        createAgentsDirectoriesIfNeeded(url: agentsURL)
        
        return agentsURL
    }
    
    static func createAgentsDirectoriesIfNeeded(url: URL) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            try? fileManager.createDirectory(at: url,
                                             withIntermediateDirectories: true,
                                             attributes: nil)
            ["clippit", "links", "merlin"].forEach {
                guard let agentsArchiveURL = Bundle.main.url(forResource: "\($0).agent", withExtension: "zip") else {
                    return
                }
                try? fileManager.copyItem(at: agentsArchiveURL, to: url.appendingPathComponent("\($0).agent.zip"))
            }
        }
    }
    
    static func agentNames() -> [String] {
        var agentNames: [String] = []
        let fileManager = FileManager.default
        guard let items = try? fileManager.contentsOfDirectory(at: agentsURL(),
                                                               includingPropertiesForKeys: nil,
                                                               options: []) else {
            return []
        }
        
        for item in items {
            if item.hasDirectoryPath && item.lastPathComponent.hasSuffix(".agent") {
                agentNames.append(item.lastPathComponent.replacingOccurrences(of: ".agent", with: ""))
            }
        }
        return agentNames.sorted()
    }
    
    static func randomAgentName() -> String? {
        agentNames().randomElement()
    }
}

