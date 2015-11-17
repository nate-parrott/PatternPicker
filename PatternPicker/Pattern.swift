//
//  Pattern.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/15/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

class Pattern: NSObject {
    init(type: PatternType, primaryColor: UIColor, secondaryColor: UIColor?) {
        self.type = type
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        super.init()
    }
    
    enum PatternType {
        case SolidColor
        case LinearGradient(endPoint: CGPoint)
        case RadialGradient
        case TonePattern(imageName: String)
        
        var involvesSecondaryColor: Bool {
            get {
                switch self {
                case .SolidColor: return false
                default: return true
                }
            }
        }
    }
    
    class func allTypes() -> [PatternType] {
        return [.SolidColor, .LinearGradient(endPoint: CGPointMake(0, 1)), .LinearGradient(endPoint: CGPointMake(1, 1)), .RadialGradient, .TonePattern(imageName: "CheckerboardPattern"), .TonePattern(imageName: "StripedPattern"), .TonePattern(imageName: "PolkaDotPattern")]
    }
    
    let primaryColor: UIColor
    let secondaryColor: UIColor?
    let type: PatternType
    
    var secondaryColorOrDefault: UIColor {
        if let s = secondaryColor {
            return s
        } else {
            let (h,s,v,a) = primaryColor.hsva
            return UIColor(hue: h, saturation: s, brightness: v * 0.5, alpha: a)
        }
    }
    
    private class GradientView: UIView {
        override class func layerClass() -> AnyClass {
            return CAGradientLayer.self
        }
        var gradientLayer: CAGradientLayer {
            get {
                return self.layer as! CAGradientLayer
            }
        }
    }
    
    private class PlainView: UIView {
        
    }
    
    func renderAsView(prev: UIView?) -> UIView {
        switch type {
        case .SolidColor:
            let gradient = prev as? GradientView ?? GradientView()
            gradient.gradientLayer.locations = [0, 1]
            gradient.gradientLayer.colors = [primaryColor.CGColor, primaryColor.CGColor]
            return gradient
        case .LinearGradient(endPoint: let endPoint):
            let gradient = prev as? GradientView ?? GradientView()
            gradient.gradientLayer.locations = [0, 1]
            gradient.gradientLayer.colors = [primaryColor.CGColor, (secondaryColor ?? UIColor.clearColor()).CGColor]
            gradient.gradientLayer.startPoint = CGPointZero
            gradient.gradientLayer.endPoint = endPoint
            return gradient
        case .RadialGradient:
            // TODO: gradient image caching?
            let size = CGSizeMake(100, 100)
            UIGraphicsBeginImageContextWithOptions(size, true, 1)
            let secondary = secondaryColorOrDefault
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradientCreateWithColors(colorSpace, [primaryColor.CGColor, secondary.CGColor, secondary.CGColor], [0, 0.5, 1])
            let center = CGPointMake(size.width/2, size.height/2)
            CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), gradient, center
, 0, center, size.height, [])
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageView = prev as? UIImageView ?? UIImageView()
            imageView.image = image
            return imageView
        case .TonePattern(imageName: let imageName):
            // TODO: image caching
            let image = UIImage(named: imageName)!
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            primaryColor.setFill()
            let rect = CGRectMake(0, 0, image.size.width, image.size.height)
            UIBezierPath(rect: rect).fill()
            CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, image.CGImage)
            secondaryColorOrDefault.setFill()
            UIBezierPath(rect: rect).fill()
            let patternImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let view = prev as? PlainView ?? PlainView()
            view.backgroundColor = UIColor(patternImage: patternImage)
            return view
        }
    }
}

func ==(lhs: Pattern.PatternType, rhs: Pattern.PatternType) -> Bool {
    switch (lhs, rhs) {
    case (.SolidColor, .SolidColor): return true
    case (.LinearGradient(endPoint: let p1), .LinearGradient(endPoint: let p2)):
        return CGPointEqualToPoint(p1, p2)
    case (.RadialGradient, .RadialGradient): return true
    case (.TonePattern(imageName: let n1), .TonePattern(imageName: let n2)): return n1 == n2
    default: return false
    }
}
