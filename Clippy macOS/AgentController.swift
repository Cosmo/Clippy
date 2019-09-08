//
//  AgentController.swift
//  Clippy macOS
//
//  Created by Devran on 07.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Cocoa
import AVKit
import SpriteKit

class AgentController {
    var player: AVPlayer = {
        return AVPlayer()
    }()
    
    var agent: AgentCharacterDescription?
    var agentView: AgentView?
    
    init() {
    }
    
    convenience init(agentView: AgentView) {
        self.init()
        self.agentView = agentView
    }
    
    func run(name: String) throws {
        print(name)
        guard let agent = AgentCharacterDescription(resourceName: name) else { return }
        self.agent = agent
        guard let animation = agent.findAnimation("Greeting") else { return }
        play(animation: animation)
    }
    
    func audioActionForFrame(frame: AgentFrame) -> SKAction? {
        guard let agent = agent, let soundNumber = frame.soundNumber else { return nil }
        let soundURL = agent.basePath.appendingPathComponent("sounds").appendingPathComponent("\(agent.resourceName)_\(soundNumber).mp3")
        let action = SKAction.run {
            let playerItem = AVPlayerItem(url: soundURL)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.volume = 1.0
            self.player.play()
        }
        return action
    }
    
    func animate() {
        guard let agent = agent else { return }
        let animation = agent.animations.randomElement()!
        play(animation: animation)
    }
    
    func mergeImages(_ images: [CGImage], width: Int, height: Int) -> CGImage? {
        var data = Data(capacity: 0)
        guard let colorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear) else { return nil }
        let image = data.withUnsafeMutableBytes({ (bytes: UnsafeMutableRawBufferPointer) -> CGImage? in
            guard let context = CGContext(data: nil,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: 0,
                                    space: colorSpace,
                                    bitmapInfo: 1) else {
                                        return nil
            }
            for image in images {
                context.draw(image, in: CGRect(x: 0,
                                               y: 0,
                                               width: image.width,
                                               height: image.height))
            }
            return context.makeImage()
        })
        
        return image
    }
    
//    private func drawLogoIn(_ image: NSImage, _ logo: NSImage, position: CGPoint) -> NSImage {
//        let renderer = UIGraphicsImageRenderer(size: image.size)
//        return renderer.image { context in
//            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
//            logo.draw(in: CGRect(origin: position, size: logo.size))
//        }
//    }
    
    func play(animation: AgentAnimation) {
        guard let agent = agent else { return }
        print(animation.name)
        
        var actions: [SKAction] = []
        let width = agent.character.width
        let height = agent.character.height
        
        DispatchQueue.global(qos: .background).async {
            
            for frame in animation.frames {
                if let audioAction = self.audioActionForFrame(frame: frame) {
                    actions.append(audioAction)
                }
                
                var texture: SKTexture?
                
                if frame.images.count == 1, let image = frame.images.first {
                    texture = try! agent.textureAtIndex(index: image.imageNumber)
                }
                if frame.images.count > 1 {
                    let cgImages = frame.images.reversed().map{ try! agent.textureAtIndex(index: $0.imageNumber).cgImage() }
                    if let mergedImage = self.mergeImages(cgImages, width: width, height: height) {
                        texture = SKTexture(cgImage: mergedImage)
                    }
                }
                
                let finalTexture = texture ?? (try! agent.textureAtIndex(index: 0))
                
                
                let action = SKAction.animate(with: [finalTexture], timePerFrame: frame.durationInSeconds)
                
                actions.append(action)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.agentView?.agentSprite.run(SKAction.sequence(actions))
            })
        }
        
    }
}

