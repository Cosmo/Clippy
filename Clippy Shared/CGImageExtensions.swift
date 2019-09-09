//
//  CGImageExtensions.swift
//  Clippy
//
//  Created by Devran on 08.09.19.
//  Copyright © 2019 Devran. All rights reserved.
//

import Foundation

extension CGImage {
    static func mergeImages(_ images: [CGImage]) -> CGImage? {
        guard let firstImage = images.first else { return nil }
        let width = firstImage.width
        let height = firstImage.height
        
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
}
