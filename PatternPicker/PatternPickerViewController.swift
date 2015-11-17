//
//  PatternPickerViewController.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/15/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

class PatternPickerViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    let background = UIVisualEffectView(effect: nil)
    
    var pattern = Pattern(type: .SolidColor, primaryColor: UIColor.greenColor(), secondaryColor: nil) {
        didSet {
            primaryColorPicker.color = pattern.primaryColor
            secondaryColorPicker.color = pattern.secondaryColorOrDefault
            secondaryColorPicker.hue.preview.pattern = Pattern(type: .SolidColor, primaryColor: secondaryColorPicker.color, secondaryColor: nil)
            primaryColorPicker.hue.preview.pattern = pattern
            _showSecondaryColor = pattern.type.involvesSecondaryColor
            patternTypePicker.selectedPatternType = pattern.type
            patternTypePicker.colors = (primaryColorPicker.color, secondaryColorPicker.color)
            doneButtonWithPreview.pattern = pattern
        }
    }
    var onChangedPattern: (Pattern -> ())?
    private func _updatePattern(pattern: Pattern) {
        self.pattern = pattern
        if let cb = onChangedPattern {
            cb(pattern)
        }
    }
    
    let primaryColorPicker = ColorPickerCollection()
    let secondaryColorPicker = ColorPickerCollection()
    let patternTypePicker = PatternTypePicker(frame: CGRectZero)
    let doneButtonWithPreview = PatternView()
    
    class ColorPickerCollection {
        init() {
            let c = color
            color = c
            for view in [satVal, hue, alphaSlider] {
                view.clipsToBounds = true
                view.layer.cornerRadius = PatternPickerView.rounding
            }
            hue.onHueChanged = {
                [weak self]
                (hue) in
                let (_,s,v,a) = self!.color.hsva
                self!._updateColor(UIColor(hue: CGFloat(hue), saturation: s, brightness: v, alpha: a))
            }
            satVal.onSatValChanged = {
                [weak self]
                (satVal) in
                let (sat, val) = satVal
                let (h,_,_,a) = self!.color.hsva
                self!._updateColor(UIColor(hue: h, saturation: CGFloat(sat), brightness: CGFloat(val), alpha: a))
            }
            alphaSlider.onSelectedAlphaChanged = {
                [weak self]
                (alphaVal) in
                let (h,s,v,_) = self!.color.hsva
                self!._updateColor(UIColor(hue: h, saturation: s, brightness: v, alpha: CGFloat(alphaVal)))
            }
            
        }
        var color = UIColor.greenColor() {
            didSet {
                let (h,s,v,a) = color.hsva
                hue.hue = Float(h)
                satVal.satVal = (Float(s), Float(v))
                satVal.hue = Float(h)
                alphaSlider.selectedAlpha = Float(a)
                alphaSlider.hsv = (Float(h), Float(s), Float(v))
            }
        }
        var onColorChange: (UIColor -> ())?
        
        let hue = ColorCell(frame: CGRectZero)
        let satVal = SatValGrid()
        let alphaSlider = AlphaSlider()
        
        private func _updateColor(color: UIColor) {
            self.color = color
            if let cb = onColorChange {
                cb(color)
            }
        }
        
        var views: [UIView] {
            get {
                return [hue, satVal, alphaSlider]
            }
        }
    }
    
    override func loadView() {
        self.view = UIScrollView()
    }
    
    var scrollView: UIScrollView! {
        get {
            return self.view as! UIScrollView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(background)
        view.backgroundColor = UIColor.clearColor()
        
        let tapRec = UITapGestureRecognizer(target: self, action: "dismiss:")
        background.addGestureRecognizer(tapRec)
        
        primaryColorPicker.hue.label.text = NSLocalizedString("Fill", comment: "")
        secondaryColorPicker.hue.label.text = NSLocalizedString("Secondary color", comment: "")
        
        patternTypePicker.backgroundColor = UIColor.whiteColor()
        patternTypePicker.clipsToBounds = true
        patternTypePicker.layer.cornerRadius = PatternPickerView.rounding
        
        let doneButton = UIButton(type: .Custom)
        doneButton.setTitle(NSLocalizedString("Done", comment: ""), forState: .Normal)
        doneButton.titleLabel!.font = UIFont.boldSystemFontOfSize(15)
        doneButtonWithPreview.addSubview(doneButton)
        doneButton.frame = doneButton.superview!.bounds
        doneButton.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        doneButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        doneButtonWithPreview.clipsToBounds = true
        doneButtonWithPreview.layer.cornerRadius = PatternPickerView.rounding
        
        view.addSubview(doneButtonWithPreview)
        
        scrollView.showsVerticalScrollIndicator = false
        
        for childView in primaryColorPicker.views + secondaryColorPicker.views {
            view.addSubview(childView)
        }
        
        primaryColorPicker.onColorChange = {
            [weak self]
            (color) in
            self!._updatePattern(Pattern(type: self!.pattern.type, primaryColor: color, secondaryColor: self!.pattern.secondaryColor))
        }
        secondaryColorPicker.onColorChange = {
            [weak self]
            (color) in
            self!._updatePattern(Pattern(type: self!.pattern.type, primaryColor: self!.pattern.primaryColor, secondaryColor: color))
        }
        patternTypePicker.onSelectedPatternTypeChanged = {
            [weak self]
            (patternType) in
            self!._updatePattern(Pattern(type: patternType, primaryColor: self!.pattern.primaryColor, secondaryColor: self!.pattern.secondaryColor))
        }
        
        view.addSubview(patternTypePicker)
        
        /*primaryColorPicker.hue.rightButton.setTitle(NSLocalizedString("Done", comment: ""), forState: .Normal)
        primaryColorPicker.hue.rightButton.titleLabel!.font = UIFont.boldSystemFontOfSize(14)
        primaryColorPicker.hue.rightButtonInset = 10
        primaryColorPicker.hue.rightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        primaryColorPicker.hue.rightButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)*/
        
        let p = pattern
        self.pattern = p
    }
    
    var contentViews: [UIView] {
        get {
            return primaryColorPicker.views + [patternTypePicker] + secondaryColorPicker.views + [doneButtonWithPreview]
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var parentView: PatternPickerView!
    private var _parentViewFrameInSelfViewCoordinates: CGRect?
    
    // MARK: Content
    var _showSecondaryColor = false {
        didSet {
            view.setNeedsLayout()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                for v in self.secondaryColorPicker.views {
                    v.alpha = self._showSecondaryColor ? 1 : 0
                }
                self.viewDidLayoutSubviews()
                }) { (completed) -> Void in
                    
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        background.frame = view.bounds
        
        let margin: CGFloat = 20
        var y = margin
        
        for childView in contentViews {
            
            var height: CGFloat = 44
            if let _ = childView as? SatValGrid {
                height = 88
            }
            if !isBeingDismissed() {
                childView.frame = CGRectMake(margin, y, view.bounds.size.width - margin*2, height)
            }
            if _showSecondaryColor || !secondaryColorPicker.views.contains(childView) {
                y += height + margin
            }
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, y)
    }
    
    // MARK: Transitioning
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let dismissing = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) === self
        let duration = transitionDuration(transitionContext)
        
        viewDidLayoutSubviews()
        
        let mainHueView = primaryColorPicker.hue
        var viewsToFade = contentViews
        viewsToFade.removeAtIndex(viewsToFade.indexOf(mainHueView)!)
        
        if dismissing {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.background.effect = nil
                for v in viewsToFade {
                    v.alpha = 0
                }
                mainHueView.frame = self._parentViewFrameInSelfViewCoordinates!
                mainHueView.layoutIfNeeded()
                }, completion: { (completed) -> Void in
                    transitionContext.completeTransition(true)
            })
        } else {
            transitionContext.containerView()!.addSubview(view)
            view.frame = transitionContext.finalFrameForViewController(self)
            
            viewDidLayoutSubviews()
            
            _parentViewFrameInSelfViewCoordinates = mainHueView.superview!.convertRect(self.parentView.bounds, fromView: self.parentView)
            
            let mainHueViewFrame = mainHueView.frame
            mainHueView.frame = _parentViewFrameInSelfViewCoordinates!
            mainHueView.superview!.bringSubviewToFront(mainHueView)
            mainHueView.layoutIfNeeded()
            
            let oldAlphas = viewsToFade.map({ $0.alpha })
            for v in viewsToFade {
                v.alpha = 0
            }
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.background.effect = UIBlurEffect(style: .Dark)
                for (v, alpha) in zip(viewsToFade, oldAlphas) {
                    v.alpha = alpha
                }
                mainHueView.frame = mainHueViewFrame
                mainHueView.layoutIfNeeded()
                }, completion: { (completed) -> Void in
                    transitionContext.completeTransition(true)
            })
        }
    }
}
