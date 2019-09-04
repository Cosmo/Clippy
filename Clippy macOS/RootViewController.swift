//
//  RootViewController.swift
//  Clippy
//
//  Created by Devran on 04.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import AppKit
import SpriteKit

class RootViewController<T: Agent>: NSViewController {
    typealias Agent = T
    var agent: T
    
    var agentSize: CGSize {
        return type(of: agent).spriteSize
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
        sprite.size = agentSize
        sprite.position = CGPoint.zero
        sprite.anchorPoint = CGPoint.zero
        sprite.texture = try? agent.textureAtPosition(x: 0, y: 0)
        return sprite
    }()
    
    lazy var scene: SKScene = {
        let scene = SKScene(size: agentSize)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .clear
        scene.addChild(agentSprite)
        return scene
    }()
    
    init(agent: T) {
        self.agent = agent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = .clear
        let origin = CGPoint.zero
        let size = CGSize(width: agentSize.width * 2, height: agentSize.height * 2)
        self.view.frame = NSRect(origin: origin, size: size)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        skView.frame = view.bounds
        skView.presentScene(scene)
        self.view.addSubview(skView)
        
        agent.animate(agentAction: T.startAction, onSpriteNode: agentSprite)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        skView.frame = view.bounds
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let menu = createContextualMenu()
        NSMenu.popUpContextMenu(menu, with: event, for: self.skView)
    }
    
    func createContextualMenu() -> NSMenu {
        let menu = NSMenu(title: "Agent")
        let menuItems = [
            NSMenuItem(title: "Hide", action: nil, keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Options …", action: nil, keyEquivalent: ""),
            NSMenuItem(title: "Choose Assistant …", action: nil, keyEquivalent: ""),
            NSMenuItem(title: "Animate!", action: #selector(animateAction), keyEquivalent: "")
        ]
        
        for (index, menuItem) in menuItems.enumerated() {
            menu.insertItem(menuItem, at: index)
        }
        return menu
    }
    
    @objc func animateAction() {
        guard let randomAction = T.actions.randomElement() else { return }
        agent.animate(agentAction: randomAction, onSpriteNode: agentSprite)
        print(randomAction)
    }
}
