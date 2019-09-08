//
//  AgentViewController.swift
//  Clippy
//
//  Created by Devran on 04.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import AppKit

class AgentViewController: NSViewController {
    var agentController: AgentController
    var agentView: AgentView
    
    init() {
        agentView = AgentView()
        agentController = AgentController(agentView: agentView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let size = CGSize(width: 200, height: 200)
        view = NSView(frame: CGRect(origin: CGPoint.zero, size: size))
        view.wantsLayer = true
        view.layer?.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(agentView)
        setupConstraints()
        setupTrackingArea()
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.makeFirstResponder(self)
        try? agentController.run(name: "f1")
    }
    
    func setupConstraints() {
        agentView.translatesAutoresizingMaskIntoConstraints = false
        agentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        agentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: agentView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: agentView.bottomAnchor).isActive = true
    }
    
    func setupTrackingArea() {
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .inVisibleRect, .activeAlways]
        let trackingArea = NSTrackingArea(rect: view.frame, options: options, owner: self, userInfo: nil)
        view.addTrackingArea(trackingArea)
    }
}

extension AgentViewController {
    override func mouseEntered(with event: NSEvent) {
        self.view.superview?.window?.alphaValue = 1.0
    }
    
    override func mouseExited(with event: NSEvent) {
        self.view.superview?.window?.alphaValue = 0.5
    }
    
    @objc func animateAction() {
        agentController.animate()
    }
    
    @objc func chooseAssistantAction() {
        guard let name = AgentCharacterDescription.randomAgentName() else { return }
        try? agentController.run(name: name)
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        guard let agent = agentController.agent else {
            super.keyDown(with: event)
            return
        }
        switch Int(event.keyCode) {
        case 49: // Spacebar
            agentController.animate()
        case 36: // Spacebar
            guard let name = AgentCharacterDescription.randomAgentName() else { return }
            try? agentController.run(name: name)
        case 124: // Arrow Right Key
            guard let animation = agent.findAnimation("LookLeft") else { break }
            agentController.play(animation: animation)
        case 123: // Arrow Left Key
            guard let animation = agent.findAnimation("LookRight") else { break }
            agentController.play(animation: animation)
        case 126: // Arrow Up Key
            guard let animation = agent.findAnimation("LookUp") else { break }
            agentController.play(animation: animation)
        case 125: // Arrow Down Key
            guard let animation = agent.findAnimation("LookDown") else { break }
            agentController.play(animation: animation)
        default:
            super.keyDown(with: event)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2 {
            agentController.animate()
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        guard let _ = agentController.agent else { return }
        
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
        NSMenu.popUpContextMenu(menu, with: event, for: agentView)
    }
}
