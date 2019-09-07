//
//  KeyableWindow.swift
//  Clippy macOS
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa

class KeyableWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}
