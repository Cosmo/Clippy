//
//  AgentWindow.swift
//  Clippy macOS
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa

class AgentWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        level = NSWindow.Level.floating
        canHide = true
        backingType = .buffered
        isMovable = true
        isMovableByWindowBackground = true
        let debug = false
        if debug {
            backgroundColor = .white
            styleMask = [.titled]
        } else {
            backgroundColor = .clear
        }
        
        // contentAspectRatio = CGSize(width: 1, height: 1)
        
        /// Fixes glitches
        hasShadow = false
        isOpaque = true
        delegate = self
        
    }
}

extension AgentWindow: NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        alphaValue = 0.5
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        alphaValue = 1.0
    }
}
