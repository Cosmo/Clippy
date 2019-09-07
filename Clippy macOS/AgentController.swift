//
//  AgentController.swift
//  Clippy macOS
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa
import AVKit
import SpriteKit

class AgentController {
    var player: AVPlayer = {
        return AVPlayer()
    }()
    
    var agent: AgentCharacterDescription?
    var agentView: AgentView?
    
    init() {
    }
    
    convenience init(agentView: AgentView) {
        self.init()
        self.agentView = agentView
    }
    
    func run(name: String) throws {
        guard let agent = AgentCharacterDescription(resourceName: name) else { return }
        self.agent = agent
        guard let animation = agent.findAnimation("Greeting") else { return }
        play(animation: animation)
    }
    
    func audioActionForFrame(frame: AgentFrame) -> SKAction? {
        guard let agent = agent, let soundNumber = frame.soundNumber else { return nil }
        let soundURL = agent.basePath.appendingPathComponent("sounds").appendingPathComponent("\(agent.resourceName)_\(soundNumber).mp3")
        let action = SKAction.run {
            let playerItem = AVPlayerItem(url: soundURL)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.volume = 1.0
            self.player.play()
        }
        return action
    }
    
    func animate() {
        guard let agent = agent else { return }
        let animation = agent.animations.randomElement()!
        play(animation: animation)
    }
    
    func play(animation: AgentAnimation) {
        guard let agent = agent else { return }
        print(animation.name)
        
        var actions: [SKAction] = []
        
        for frame in animation.frames {
            if let audioAction = audioActionForFrame(frame: frame) {
                actions.append(audioAction)
            }
            let image = frame.images.last
            let texture = try! agent.textureAtIndex(index: image?.imageNumber ?? agent.rows * agent.columns)
            let action = SKAction.animate(with: [texture], timePerFrame: frame.durationInSeconds)
            
            actions.append(action)
        }
        
        agentView?.agentSprite.run(SKAction.sequence(actions))
    }
}

