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
    var isMuted = false
    var isIdleAnimationEnabled = true
    var player: AVPlayer = {
        return AVPlayer()
    }()
    
    var agent: Agent?
    var agentView: AgentView?
    
    var delegate: AgentControllerDelegate?
    var isHidden = true
    
    init() {
    }
    
    convenience init(agentView: AgentView) {
        self.init()
        self.agentView = agentView
    }
    
    func load(name: String) throws {
        print(name)
        guard let agent = Agent(resourceName: name) else { return }
        delegate?.willLoadAgent(agent: agent)
        self.agent = agent
        showInitialFrame()
        delegate?.didLoadAgent(agent: agent)
    }
    
    func audioActionForFrame(frame: AgentFrame) -> SKAction? {
        guard let agent = agent, let soundIndex = frame.soundIndex else { return nil }
        let soundURL = agent.soundURL(forIndex: soundIndex)
        let action = SKAction.run {
            let playerItem = AVPlayerItem(url: soundURL)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.play()
            self.player.volume = self.isMuted ? 0 : 1.0
        }
        return action
    }
    
    func showInitialFrame() {
        guard let agent = agent else { return }
        self.agentView?.agentSprite.texture = SKTexture(cgImage: try! agent.textureAtIndex(index: 0))
    }
    
    func play(animation: AgentAnimation, withSoundEnabled soundEnabled: Bool = true, completion: (() -> Void)? = nil) {
        guard let agent = agent else { return }
        print(animation.name)
        
        DispatchQueue.global(qos: .background).async {
            var actions: [SKAction] = []
            
            for frame in animation.frames {
                if soundEnabled, let audioAction = self.audioActionForFrame(frame: frame) {
                    actions.append(audioAction)
                }
                
                let texture = SKTexture(cgImage: agent.imageForFrame(frame))
                texture.filteringMode = .nearest
                let action = SKAction.animate(with: [texture], timePerFrame: frame.durationInSeconds)
                actions.append(action)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.agentView?.agentSprite.removeAllActions()
                self.agentView?.agentSprite.run(SKAction.sequence(actions), completion: {
                    completion?()
                })
            })
        }
    }
    
    func animate() {
        guard let agent = agent else { return }
        let animation = agent.animations.randomElement()!
        play(animation: animation)
    }
    
    func hide() {
        delegate?.handleHide()
    }
    
    func show() {
        delegate?.handleShow()
    }
}
