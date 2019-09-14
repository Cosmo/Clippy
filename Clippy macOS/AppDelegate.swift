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
    var agentsMenuItem: NSMenuItem?
    static var agentController: AgentController?
    var lastUsedAgent: String?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        window = AgentWindow(contentRect: CGRect.zero, styleMask: [], backing: .buffered, defer: true)
        window?.title = applicationName
        window?.contentViewController = AgentViewController()
        if !Agent.agentNames().isEmpty {
            window?.makeKeyAndOrderFront(self)
        }
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
    
    func createAgentsMenu() -> NSMenu {
        let agentsMenu = NSMenu(title: "Agents")
        let agentNames = Agent.agentNames()
        
        if agentNames.isEmpty {
            agentsMenu.addItem(withTitle: "No Agents found.",
                               action: nil,
                               keyEquivalent: "")
        }
        for agentName in agentNames {
            let item = NSMenuItem(title: agentName.capitalized,
                                  action: #selector(selectAgent(sender:)),
                                  keyEquivalent: "")
            if lastUsedAgent == agentName {
                item.state = .on
            }
            agentsMenu.addItem(item)
        }
        agentsMenu.addItem(NSMenuItem.separator())
        agentsMenu.addItem(withTitle: "Reload",
                           action: #selector(reloadAction(sender:)),
                           keyEquivalent: "")
        return agentsMenu
    }
    
    func setupStatusBarMenu() {
        // Status bar menu
        let statusBarMenu = NSMenu(title: "Clippy")
        agentsMenuItem = NSMenuItem(title: "Agents", action: nil, keyEquivalent: "")
        
        statusBarMenu.addItem(withTitle: "Show", action: #selector(showAction(sender:)), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "Hide", action: #selector(hideAction(sender:)), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "Mute", action: #selector(toggleMuteAction(sender:)), keyEquivalent: "")
        
        statusBarMenu.addItem(withTitle: "Idle Animations", action: #selector(toggleIdelAnimation(sender:)), keyEquivalent: "").state = .on
        
        statusBarMenu.addItem(NSMenuItem.separator())
        guard let menuItem = agentsMenuItem else  { return }
        statusBarMenu.addItem(menuItem)
        statusBarMenu.addItem(withTitle: "Show in Finder",
                           action: #selector(openFolderAction(sender:)),
                           keyEquivalent: "")
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "Quit \(applicationName)", action: #selector(quitAction(sender:)), keyEquivalent: "")
        
        // Agents menu
        statusBarMenu.setSubmenu(createAgentsMenu(), for: menuItem)
        
        statusItem?.menu = statusBarMenu
    }
    
    @objc func quitAction(sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
    
    @objc func reloadAction(sender: AnyObject) {
        agentsMenuItem?.submenu = createAgentsMenu()
    }
    
    @objc func openFolderAction(sender: AnyObject) {
        NSWorkspace.shared.open(Agent.agentsURL())
    }
    
    @objc func hideAction(sender: AnyObject) {
        AppDelegate.agentController?.hide()
    }
    
    @objc func showAction(sender: AnyObject) {
        window?.makeKeyAndOrderFront(self)
    }
    
    @objc func toggleMuteAction(sender: AnyObject) {
        guard let menuItem = sender as? NSMenuItem else { return }
        guard let isMuted = AppDelegate.agentController?.isMuted else { return }
        let newValue = !isMuted
        AppDelegate.agentController?.isMuted = newValue
        menuItem.state = newValue ? .on : .off
    }
    
    @objc func toggleIdelAnimation(sender: AnyObject) {
        guard let menuItem = sender as? NSMenuItem else { return }
        guard let isIdle = AppDelegate.agentController?.isIdleAnimationEnabled  else { return }
        
        let newValue = !isIdle
        AppDelegate.agentController?.isIdleAnimationEnabled = newValue
        menuItem.state = newValue ? .on : .off
    }
    
    @objc func selectAgent(sender: AnyObject) {
        guard let menuItem = sender as? NSMenuItem else { return }
        let name = menuItem.title.lowercased()
        
        if let isVisible = window?.isVisible, isVisible == true {
            try? AppDelegate.agentController?.load(name: name)
            if let animation = AppDelegate.agentController?.agent?.findAnimation("Show") {
                AppDelegate.agentController?.play(animation: animation)
            }
        } else {
            lastUsedAgent = name
            window?.makeKeyAndOrderFront(self)
        }
        
        agentsMenuItem?.submenu = createAgentsMenu()
    }
}
