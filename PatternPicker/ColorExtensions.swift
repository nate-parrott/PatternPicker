//
//  ColorExtensions.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/16/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

extension UIColor {
    var hsva: (CGFloat, CGFloat, CGFloat, CGFloat)! {
        get {
            var h = CGFloat()
            var s = CGFloat()
            var v = CGFloat()
            var a = CGFloat()
            if getHue(&h, saturation: &s, brightness: &v, alpha: &a) {
                return (h, s, v, a)
            } else {
                if getWhite(&v, alpha: &a) {
                    return (0, 0, v, a)
                } else {
                    return nil
                }
            }
        }
    }
}
