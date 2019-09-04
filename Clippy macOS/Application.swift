//
//  Application.swift
//  Clippy macOS
//
//  Created by Devran on 04.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa

class Application: NSApplication {
    let strongDelegate = AppDelegate()
    
    override init() {
        super.init()
        self.delegate = strongDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
