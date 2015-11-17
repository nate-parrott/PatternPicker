//
//  ColorCell.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/16/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

class ColorCell: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // fuck this shit
    }
    
    let label = UILabel()
    let preview = PatternView()
    let hueSlider = HueSlider()
    let rightButton = UIButton()
    let hueMarker = UIImageView(image: UIImage(named: "HueArrow")!)
    let touchView = UIView()
    var rightButtonInset: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    func setup() {
        addSubview(hueSlider)
        addSubview(touchView)
        addSubview(rightButton)
        addSubview(label)
        addSubview(preview)
        addSubview(hueMarker)
        
        preview.patternScale = 0.1
        
        let tap = UITapGestureRecognizer(target: self, action: "tapped:")
        touchView.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: "panned:")
        addGestureRecognizer(pan)
        
        hueMarker.alpha = 0.5
        label.alpha = 0.5
        rightButton.alpha = 0.5
        
        let h = self.hue
        self.hue = h
        
        label.font = UIFont.boldSystemFontOfSize(14)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    var hue: Float = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var onHueChanged: (Float -> ())?
    
    func tapped(rec: UITapGestureRecognizer) {
        pickHueAtX(rec.locationInView(self).x)
    }
    
    func panned(rec: UIPanGestureRecognizer) {
        pickHueAtX(rec.locationInView(self).x)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = bounds.size.height
        let hueHeight: CGFloat = 4
        let previewSize: CGFloat = 12
        let xInset: CGFloat = 10
        
        preview.frame = CGRectMake(xInset, (bounds.size.height - preview.frame.size.height)/2, previewSize, previewSize)
        preview.clipsToBounds = true
        preview.layer.cornerRadius = previewSize/2
        
        label.sizeToFit()
        label.frame = CGRectMake(preview.frame.origin.x + preview.frame.size.width + xInset, (bounds.size.height - label.frame.size.height)/2, label.frame.size.width, label.frame.size.height)
        
        rightButton.frame = CGRectMake(self.bounds.size.width - buttonWidth - rightButtonInset, 0, buttonWidth, self.bounds.size.height)
        
        hueSlider.frame = CGRectMake(0, bounds.size.height - hueHeight, bounds.size.width, hueHeight)
        
        touchView.frame = bounds
        
        hueMarker.sizeToFit()
        hueMarker.center = CGPointMake(CGFloat(hue) * bounds.size.width, bounds.size.height - hueHeight - hueMarker.bounds.size.height - 1)
    }
    
    func pickHueAtX(x: CGFloat) {
        hue = min(1, max(0, Float(x / bounds.size.width)))
        if let cb = onHueChanged {
            cb(hue)
        }
    }
}
