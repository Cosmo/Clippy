//
//  AgentExtensions.swift
//  Sprite-iOS
//
//  Created by Devran on 21.08.19.
//

import Foundation
import SpriteKit

extension Agent {
    var columns: Int {
        return Int(Self.spriteMap.size().width / Self.spriteSize.width)
    }
    var rows: Int {
        return Int(Self.spriteMap.size().height / Self.spriteSize.height)
    }
    
    func textureAtPosition(x: Int, y: Int) throws -> SKTexture {
        guard (0...rows ~= y && 0...columns ~= x) else { throw AgentError.frameOutOfBounds }
        
        let unitWidth = Self.spriteSize.width / Self.spriteMap.size().width
        let unitHeight = Self.spriteSize.height / Self.spriteMap.size().height
        
        let rectX = CGFloat(x) * unitWidth
        let rectY = CGFloat((rows - 1) - y) * unitHeight
        
        let textureRect = CGRect(x: rectX, y: rectY, width: unitWidth, height: unitHeight)
        let texture = SKTexture(rect: textureRect, in: Self.spriteMap)
        texture.filteringMode = .nearest
        return texture
    }
    
    func animate(agentAction: Action, onSpriteNode spriteNode: SKSpriteNode) {
        let allFrames = frames(from: agentAction).compactMap { $0 }
        let actions = allFrames.map { SKAction.animate(with: [$0.texture], timePerFrame: Double($0.duration)/1000) }
        
        spriteNode.run(SKAction.sequence(actions))
    }
}
