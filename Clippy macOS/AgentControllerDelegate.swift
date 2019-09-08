//
//  AgentControllerDelegate.swift
//  Clippy macOS
//
//  Created by Devran on 08.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

protocol AgentControllerDelegate {
    func willRunAgent(agent: AgentCharacterDescription)
    func didRunAgent(agent: AgentCharacterDescription)
}
