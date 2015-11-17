//
//  PatternTypePicker.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/16/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

class PatternTypePicker: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var patternViews = [PatternView]()
    let selectedMarker = UIView(frame: CGRectMake(0, 0, 8, 8))
    
    func setup() {
        patternViews = makeAllPatternsWithColors(colors.0, secondary: colors.1).map({ (pattern) in
            let view = PatternView(frame: CGRectZero)
            view.pattern = pattern
            view.patternScale = 0.2
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapped:"))
            return view
        })
        for v in patternViews {
            addSubview(v)
        }
        
        addSubview(selectedMarker)
        selectedMarker.backgroundColor = UIColor.whiteColor()
        selectedMarker.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 4))
        
        let c = colors
        self.colors = c
        let t = selectedPatternType
        self.selectedPatternType = t
                
        showsHorizontalScrollIndicator = false
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        let pattern = (sender.view as! PatternView).pattern
        selectedPatternType = pattern.type
        if let cb = onSelectedPatternTypeChanged {
            cb(selectedPatternType)
        }
    }
    
    var colors: (UIColor, UIColor) = (UIColor.greenColor(), UIColor.blackColor()) {
        didSet {
            let (primary, secondary) = colors
            let patterns = makeAllPatternsWithColors(primary, secondary: secondary)
            for (pattern, view) in zip(patterns, patternViews) {
                view.pattern = pattern
            }
        }
    }
    
    var selectedPatternType: Pattern.PatternType = Pattern.PatternType.SolidColor {
        didSet {
            setNeedsLayout()
        }
    }
    var onSelectedPatternTypeChanged: (Pattern.PatternType -> ())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 0
        let margin: CGFloat = 4
        for view in patternViews {
            view.frame = CGRectMake(x, 0, bounds.size.height, bounds.size.height)
            x += bounds.size.height + margin
            if view.pattern.type == selectedPatternType {
                selectedMarker.center = view.center
            }
        }
        contentSize = CGSizeMake(x, bounds.size.height)
    }
    
    
    func makeAllPatternsWithColors(primary: UIColor, secondary: UIColor) -> [Pattern] {
        return Pattern.allTypes().map({ Pattern(type: $0, primaryColor: primary, secondaryColor: secondary) })
    }
}
