//
//  RootViewController.swift
//  Clippy
//
//  Created by Devran on 04.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import AppKit
import SpriteKit
import AVKit

class RootViewController: NSViewController {
    var agent: AgentCharacterDescription {
        didSet {
            view.superview?.window?.contentAspectRatio = CGSize(width: agent.character.width, height: agent.character.height)
        }
    }
    
    var skView: SKView = {
        let skView = GhostSKView()
        skView.wantsLayer = true
        skView.allowsTransparency = true
        skView.layer?.backgroundColor = .clear
        return skView
    }()
    
    lazy var agentSprite: SKSpriteNode = {
        let sprite = SKSpriteNode()
        sprite.size = agent.character.size
        sprite.position = CGPoint.zero
        sprite.anchorPoint = CGPoint.zero
        return sprite
    }()
    
    lazy var scene: SKScene = {
        let scene = SKScene(size: agent.character.size)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .clear
        scene.addChild(agentSprite)
        return scene
    }()
    
    var player: AVPlayer = {
        return AVPlayer()
    }()
    
    init() {
        self.agent = AgentCharacterDescription.loadAgent(resourceName: "links")!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let origin = CGPoint.zero
        let size = CGSize(width: agent.character.width * 2, height: agent.character.height * 2)
        view = NSView(frame: NSRect(origin: origin, size: size))
        view.wantsLayer = true
        view.layer?.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        skView.frame = view.bounds
        skView.presentScene(scene)
        view.addSubview(skView)
        
        startAgent()
        
        view.window?.makeFirstResponder(self)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        skView.frame = view.bounds
    }
    
    func createContextualMenu() -> NSMenu {
        let menu = NSMenu(title: "Agent")
        let menuItems = [
            NSMenuItem(title: "Hide", action: nil, keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Options …", action: nil, keyEquivalent: ""),
            NSMenuItem(title: "Choose Assistant …", action: #selector(swapAssistant), keyEquivalent: ""),
            NSMenuItem(title: "Animate!", action: #selector(animateAction), keyEquivalent: "")
        ]
        
        for (index, menuItem) in menuItems.enumerated() {
            menu.insertItem(menuItem, at: index)
        }
        return menu
    }
    
    @objc func animateAction() {
        animate(onNode: agentSprite)
    }
    
    @objc func swapAssistant() {
        guard let assistant = AgentCharacterDescription.availableAgents().randomElement() else { return }
        guard let agent = AgentCharacterDescription.loadAgent(resourceName: assistant) else { return }
        self.agent = agent
        startAgent()
    }
    
    func startAgent() {
        agentSprite.texture = try? agent.textureAtIndex(index: 0)
    }
}

extension RootViewController {
    func audioActionForFrame(frame: AgentFrame) -> SKAction? {
        guard let soundNumber = frame.soundNumber else { return nil }
        let soundURL = agent.basePath.appendingPathComponent("sounds").appendingPathComponent("\(agent.resourceName)_\(soundNumber).mp3")
        let action = SKAction.run {
            let playerItem = AVPlayerItem(url: soundURL)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.volume = 1.0
            self.player.play()
        }
        return action
    }
    
    func animate(onNode node: SKNode) {
        let animation = agent.animations.randomElement()!
        play(animation: animation, onNode: node)
    }
    
    func play(animation: AgentAnimation, onNode node: SKNode) {
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
        
        node.run(SKAction.sequence(actions))
    }
}

extension RootViewController {
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case 49: // Spacebar
            animate(onNode: agentSprite)
        case 124: // Right Key
            guard let animation = agent.findAnimation("LookLeft") else { break }
            play(animation: animation, onNode: agentSprite)
        case 123:
            guard let animation = agent.findAnimation("LookRight") else { break }
            play(animation: animation, onNode: agentSprite)
        case 126:
            guard let animation = agent.findAnimation("LookUp") else { break }
            play(animation: animation, onNode: agentSprite)
        case 125:
            guard let animation = agent.findAnimation("LookDown") else { break }
            play(animation: animation, onNode: agentSprite)
        default:
            super.keyDown(with: event)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2 {
            animate(onNode: agentSprite)
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let menu = createContextualMenu()
        NSMenu.popUpContextMenu(menu, with: event, for: skView)
    }
}
