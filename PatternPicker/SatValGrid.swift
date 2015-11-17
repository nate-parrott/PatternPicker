//
//  SatValGrid.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/15/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

class SatValGrid: UIImageView {
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        setup()
    }
    
    let marker = UIView()
    
    func setup() {
        addSubview(marker)
        marker.bounds = CGRectMake(0, 0, 8, 8)
        marker.backgroundColor = UIColor.whiteColor()
        marker.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 4.0))
        
        let sv = satVal
        satVal = sv
        let h = hue
        hue = h
        
        userInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "_move:"))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "_move:"))
    }
    
    func _move(sender: UIGestureRecognizer) {
        let pos = sender.locationInView(self)
        let sat = Float(max(0, min(1, pos.x / bounds.size.width)))
        let val = Float(max(0, min(1, pos.y / bounds.size.height)))
        satVal = (sat, val)
        if let cb = onSatValChanged {
            cb(sat, val)
        }
    }
    
    var hue: Float = 0 {
        didSet {
            render()
        }
    }
    
    func render() {
        let pixels = UnsafeMutablePointer<PixelData>.alloc(128 * 128)
        for y in 0..<128 {
            for x in 0..<128 {
                var r: Float = 0
                var g: Float = 0
                var b: Float = 0
                HSVtoRGB(&r, &g, &b, hue * 360.0, Float(x) / 128.0, Float(y) / 128.0)
                pixels[y*128 + x] = PixelData(a: 255, r: UInt8(r*Float(255.0)), g: UInt8(g*Float(255.0)), b: UInt8(b*Float(255.0)))
            }
        }
        self.image = imageFromARGB32Bitmap(pixels, width: 128, height: 128)
        pixels.destroy()
    }
    
    var satVal: (Float, Float) = (0, 0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    var onSatValChanged: ((Float, Float) -> ())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let (s, v) = satVal
        marker.center = CGPointMake(CGFloat(s) * bounds.size.width, CGFloat(v) * bounds.size.height)
    }
}
