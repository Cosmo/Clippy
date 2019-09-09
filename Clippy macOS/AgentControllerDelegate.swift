//
//  AgentControllerDelegate.swift
//  Clippy macOS
//
//  Created by Devran on 08.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa

protocol AgentControllerDelegate {
    func willRunAgent(agent: Agent)
    func didRunAgent(agent: Agent)
    
    var window: NSWindow? { get }
}
