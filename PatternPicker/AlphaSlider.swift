//
//  AlphaSlider.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/15/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

class AlphaSlider: UIView {
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        get {
            return self.layer as! CAGradientLayer
        }
    }
    
    var marker = UIView()
    
    func setup() {
        let h = hsv
        self.hsv = h
        backgroundColor = UIColor(patternImage: UIImage(named: "Checkerboard")!)
        
        addSubview(marker)
        marker.bounds = CGRectMake(0, 0, 8, 8)
        marker.backgroundColor = UIColor.whiteColor()
        marker.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 4))
        
        let a = selectedAlpha
        selectedAlpha = a
        
        userInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "_moved:"))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "_moved:"))
    }
    
    func _moved(sender: UIGestureRecognizer) {
        selectedAlpha = Float(max(0, min(1, sender.locationInView(self).x / bounds.size.width)))
        if let cb = onSelectedAlphaChanged {
            cb(selectedAlpha)
        }
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        setup()
    }
    
    var hsv: (Float, Float, Float) = (0,0,0) {
        didSet {
            let (h,s,v) = hsv
            gradientLayer.startPoint = CGPointZero
            gradientLayer.endPoint = CGPointMake(1, 0)
            gradientLayer.colors = [UIColor(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(v), alpha: 0).CGColor, UIColor(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(v), alpha: 1).CGColor]
        }
    }
    
    var selectedAlpha: Float = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var onSelectedAlphaChanged: (Float -> ())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        marker.center = CGPointMake(bounds.size.width * CGFloat(selectedAlpha), bounds.size.height / 2)
    }
}
