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
        
        setupStatusBar()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
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
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "Quit \(applicationName)", action: #selector(quitAction(sender:)), keyEquivalent: "")
        
        // Agents menu
        let agentsMenu = NSMenu(title: "Agents")
        let agentNames = AgentCharacterDescription.agentNames()
        let agentsPath = AgentCharacterDescription.agentsURL().absoluteString
        if FileManager.default.fileExists(atPath: agentsPath, isDirectory: nil) {
            if agentNames.isEmpty {
                agentsMenu.addItem(withTitle: "No Agents found.",
                                   action: nil,
                                   keyEquivalent: "")
                agentsMenu.addItem(NSMenuItem.separator())
                agentsMenu.addItem(withTitle: "Open Agents Folder",
                                   action: #selector(openFolderAction(sender:)),
                                   keyEquivalent: "")
                agentsMenu.addItem(NSMenuItem.separator())
                agentsMenu.addItem(withTitle: "Reload…",
                                   action: #selector(reloadAction(sender:)),
                                   keyEquivalent: "")
            } else {
                for agentName in agentNames {
                    agentsMenu.addItem(withTitle: agentName.capitalized, action: nil, keyEquivalent: "")
                }
            }
        } else {
            agentsMenu.addItem(withTitle: "Create Agents Folder",
                               action: #selector(createFolderAction(sender:)),
                               keyEquivalent: "")
        }
        statusBarMenu.setSubmenu(agentsMenu, for: agentsItem)
        
        statusItem?.menu = statusBarMenu
    }
    
    @objc func quitAction(sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
    
    @objc func reloadAction(sender: AnyObject) {
        print("Reloading.")
    }
    
    @objc func openFolderAction(sender: AnyObject) {
        NSWorkspace.shared.open(AgentCharacterDescription.agentsURL())
    }
    
    @objc func createFolderAction(sender: AnyObject) {
        let agentsURL = AgentCharacterDescription.agentsURL()
        try? FileManager.default.createDirectory(at: agentsURL, withIntermediateDirectories: true, attributes: nil)
        openFolderAction(sender: sender)
    }
}
