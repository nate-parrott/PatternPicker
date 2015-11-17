//
//  HueSlider.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/15/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

class HueSlider: UIImageView {
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        render()
        contentMode = .ScaleToFill
    }
    
    func render() {
        let pixels = UnsafeMutablePointer<PixelData>.alloc(256)
        for i in 0..<256 {
            var r: Float = 0
            var g: Float = 0
            var b: Float = 0
            HSVtoRGB(&r, &g, &b, Float(i) / 255.0 * 360, 1, 1)
            pixels[i] = PixelData(a: 255, r: UInt8(r*Float(255.0)), g: UInt8(g*Float(255.0)), b: UInt8(b*Float(255.0)))
        }
        self.image = imageFromARGB32Bitmap(pixels, width: 256, height: 1)
        pixels.destroy()
    }
}
