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
        
        let acd = AgentCharacterDescription(url: Bundle.main.url(forResource: "sample", withExtension: "acd")!)
        print(acd?.character.width)
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
        
        applicationSubMenu.addItem(withTitle: "Quit \(applicationName)",
            action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        mainMenu.setSubmenu(applicationSubMenu, for: applicationMenuItem)
        
        NSApp.mainMenu = mainMenu
    }
}
