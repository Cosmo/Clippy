//
//  AppDelegate.swift
//  Clippy macOS
//
//  Created by Devran on 03.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let applicationName = "Clippy"
    var window: NSWindow?
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = AgentWindow(contentRect: CGRect.zero, styleMask: [], backing: .buffered, defer: true)
        window?.title = applicationName
        window?.contentViewController = AgentViewController()
        window?.makeKeyAndOrderFront(self)
        window?.center()
        
        setupMenu()
        setupStatusBar()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func setupMenu() {
        // Main menu
        let mainMenu = NSMenu(title: "MainMenu")
        let appItem = mainMenu.addItem(withTitle: "Application", action: nil, keyEquivalent: "")
        
        // Application menu
        let appMenu = NSMenu(title: "Application")
        appMenu.addItem(withTitle: "Quit \(applicationName)", action: #selector(quit(sender:)), keyEquivalent: "q")
        mainMenu.setSubmenu(appMenu, for: appItem)
        
        NSApp.mainMenu = mainMenu
    }
    
    func setupStatusBar() {
        let statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.title = "📎"
        }
        
        setupStatusBarMenu()
    }
    
    func setupStatusBarMenu() {
        // Status bar menu
        let statusBarMenu = NSMenu(title: "Clippy")
        let agentsItem = NSMenuItem(title: "Agents", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(agentsItem)
        statusBarMenu.addItem(withTitle: "Quit", action: #selector(quit(sender:)), keyEquivalent: "")
        
        // Agents menu
        let agentsMenu = NSMenu(title: "Agents")
        for agentName in AgentCharacterDescription.agentNames() {
            agentsMenu.addItem(withTitle: agentName.capitalized, action: nil, keyEquivalent: "")
        }
        statusBarMenu.setSubmenu(agentsMenu, for: agentsItem)
        
        statusItem?.menu = statusBarMenu
    }
    
    @objc func quit(sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
}
