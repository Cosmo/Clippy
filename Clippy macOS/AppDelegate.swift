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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let agent = Clippy()
        window = NSWindow(contentViewController: RootViewController(agent: agent))
        window?.styleMask = debug ? [.resizable, .titled] : []
        window?.canHide = true
        window?.backingType = .buffered
        window?.isOpaque = false
        window?.isMovable = true
        window?.isMovableByWindowBackground = true
        window?.hasShadow = false
        window?.backgroundColor = .clear
        window?.contentAspectRatio = Clippy.spriteSize
        window?.minSize = Clippy.spriteSize
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
        let mainMenu = NSMenu(title:"MainMenu")
        
        let applicationMenuItem = mainMenu.addItem(withTitle: "Application", action: nil, keyEquivalent: "")
        let applicationSubMenu = NSMenu(title:"Application")
        
        applicationSubMenu.addItem(NSMenuItem(title: "hello", action: nil, keyEquivalent: ""))
        
        let title = NSLocalizedString("Hide", comment: "Hide menu item") + " " + "Clippy"
        let hideMenuItem = applicationSubMenu.addItem(withTitle: title, action: #selector(NSApplication.hide(_:)), keyEquivalent:"h")
        hideMenuItem.target = NSApp
        
        mainMenu.setSubmenu(applicationSubMenu, for: applicationMenuItem)
        
        NSApp.mainMenu = mainMenu
    }
}
