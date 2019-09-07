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
    let applicationName = "Clippy"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        window = AgentWindow(contentRect: CGRect.zero, styleMask: [], backing: .buffered, defer: true)
        window?.title = applicationName
        window?.contentViewController = AgentViewController()
        window?.makeKeyAndOrderFront(self)
        window?.center()
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
