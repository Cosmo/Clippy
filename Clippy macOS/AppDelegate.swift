//
//  AppDelegate.swift
//  Clippy macOS
//
//  Created by Devran on 03.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    let debug = false
    let applicationName = "Clippy"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window = KeyableWindow(contentViewController: AgentViewController())
        window?.title = applicationName
        window?.styleMask = debug ? [
            NSWindow.StyleMask.titled,
            NSWindow.StyleMask.resizable
        ] : []
        window?.level = NSWindow.Level.floating
        window?.titlebarAppearsTransparent = true
        window?.canHide = true
        window?.backingType = .buffered
        window?.isMovable = true
        window?.isMovableByWindowBackground = true
        window?.backgroundColor = .clear
        // window?.contentAspectRatio = CGSize(width: 1, height: 1)
        
        /// Fixes glitches
        window?.hasShadow = false
        window?.isOpaque = false
        
        window?.delegate = self
        window?.makeKeyAndOrderFront(self)
        setupMenu()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func setupMenu() {
        let mainMenu = NSMenu(title: "MainMenu")
        
        let applicationMenuItem = mainMenu.addItem(withTitle: "Application", action: nil, keyEquivalent: "")
        let applicationSubMenu = NSMenu(title:"Application")
        
        applicationSubMenu.addItem(withTitle: "Quit \(applicationName)",
            action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        mainMenu.setSubmenu(applicationSubMenu, for: applicationMenuItem)
        
        NSApp.mainMenu = mainMenu
    }
}

extension AppDelegate: NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        window?.alphaValue = 0.5
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        window?.alphaValue = 1.0
    }
}
