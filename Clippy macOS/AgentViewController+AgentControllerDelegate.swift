//
//  AgentViewController+AgentDelegate.swift
//  Clippy macOS
//
//  Created by Devran on 08.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa

extension AgentViewController: AgentControllerDelegate {
    func willLoadAgent(agent: Agent) {
        guard let oldRect = view.superview?.window?.frame else { return }
        
        var agentName = agent.resourceName
        if let name = agent.character.infos.first(where: { $0.language == "0x0009" })?.name {
            agentName = name
        }
        
        view.superview?.window?.title = agentName
        let newSize = CGSize(width: agent.character.width * 2, height: agent.character.height * 2)
        let rect = CGRect(origin: oldRect.origin, size: newSize)
        
        /// Disable animation, when the window was not moved before.
        /// This happens, when the window was initially created.
        let animated = oldRect.origin.x > 0 && oldRect.origin.y > 0
        view.superview?.window?.setFrame(rect, display: true, animate: animated)
    }
    
    func didLoadAgent(agent: Agent) {
        (NSApplication.shared.delegate as? AppDelegate)?.lastUsedAgent = agent.resourceName
    }
    
    func handleHide() {
        if let animation = agentController.agent?.findAnimation("Hide") {
            agentController.play(animation: animation) {
                self.agentController.isHidden = true
                NSApp.hide(self)
            }
        }
    }
    
    func handleShow() {
        view.superview?.window?.makeKeyAndOrderFront(self)
        agentController.isHidden = false
        /// No need to run animation, as it will be played
        /// automatically, when the window loaded.
    }
}
