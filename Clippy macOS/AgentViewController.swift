//
//  AgentViewController.swift
//  Clippy
//
//  Created by Devran on 04.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import AppKit
import SpriteKit
import AVKit

class AgentViewController: NSViewController {
    var agent: AgentCharacterDescription?
    
    lazy var skView: SKView = {
        let skView = GhostSKView()
        skView.wantsLayer = true
        skView.allowsTransparency = true
        skView.layer?.backgroundColor = .clear
        return skView
    }()
    
    lazy var agentSprite: SKSpriteNode = {
        let sprite = SKSpriteNode()
        sprite.position = CGPoint.zero
        sprite.anchorPoint = CGPoint.zero
        return sprite
    }()
    
    lazy var scene: SKScene = {
        let scene = SKScene(size: view.frame.size)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        scene.addChild(agentSprite)
        return scene
    }()
    
    var player: AVPlayer = {
        return AVPlayer()
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let origin = CGPoint.zero
        let size = CGSize(width: 400, height: 400)
        view = NSView(frame: CGRect(origin: origin, size: size))
        view.wantsLayer = true
        view.layer?.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(skView)
        skView.presentScene(scene)
        setupConstraints()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.makeFirstResponder(self)
        
        guard let name = AgentCharacterDescription.randomAgentName() else { return }
        startAssistant(name: name)
    }
    
    func setupConstraints() {
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: skView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: skView.bottomAnchor).isActive = true
    }
    
    func createContextualMenu() -> NSMenu {
        let menu = NSMenu(title: "Agent")
        let menuItems = [
            NSMenuItem(title: "Hide", action: nil, keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Options …", action: nil, keyEquivalent: ""),
            NSMenuItem(title: "Choose Assistant …", action: #selector(chooseAssistantAction), keyEquivalent: ""),
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
    
    @objc func chooseAssistantAction() {
        guard let name = AgentCharacterDescription.randomAgentName() else { return }
        startAssistant(name: name)
    }
    
    func startAssistant(name: String) {
        guard let agent = AgentCharacterDescription(resourceName: name) else { return }
        self.agent = agent
        guard let window = view.superview?.window else { return }
        window.contentAspectRatio = agent.character.size
        let size = CGSize(width: agent.character.height * 2, height: agent.character.height * 2)
        window.setContentSize(size)
        var frame = window.frame
        frame.size = size
        window.setFrame(frame, display: true, animate: true)
        // skView.setFrameSize(size)
        view.setFrameSize(size)
        agentSprite.size = size
        agentSprite.texture = try? agent.textureAtIndex(index: 0)
    }
}

extension AgentViewController {
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
    
    func animate(onNode node: SKNode) {
        guard let agent = agent else { return }
        let animation = agent.animations.randomElement()!
        play(animation: animation, onNode: node)
    }
    
    func play(animation: AgentAnimation, onNode node: SKNode) {
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
        
        node.run(SKAction.sequence(actions))
    }
}

extension AgentViewController {
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        guard let agent = agent else {
            super.keyDown(with: event)
            return
        }
        switch Int(event.keyCode) {
        case 49: // Spacebar
            animate(onNode: agentSprite)
        case 36: // Spacebar
            guard let name = AgentCharacterDescription.randomAgentName() else { return }
            startAssistant(name: name)
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
