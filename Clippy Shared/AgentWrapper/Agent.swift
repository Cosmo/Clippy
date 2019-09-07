//
//  Agent.swift
//  Sprite-iOS
//
//  Created by Devran on 21.08.19.
//

import Foundation
import SpriteKit

protocol Agent {
    associatedtype Action
    
    static var spriteMap: SKTexture { get }
    static var spriteSize: CGSize { get }
    static var actions: [Action] { get }
    
    static var startAction: Action { get }
    
    func frames(from animation: Action) -> [AgentFrameLegacy?]
}
