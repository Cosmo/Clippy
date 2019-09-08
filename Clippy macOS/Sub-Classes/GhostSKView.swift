//
//  GhostSKView.swift
//  Clippy macOS
//
//  Created by Devran on 04.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import SpriteKit

class GhostSKView: SKView {
    open override func hitTest(_ point: NSPoint) -> NSView? {
        return superview
    }
}
