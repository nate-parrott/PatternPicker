//
//  Pixel.swift
//  PatternPicker
//
//  Created by Nate Parrott on 11/15/15.
//  Copyright © 2015 Nate Parrott. All rights reserved.
//

import UIKit

// from http://stackoverflow.com/questions/30958427/pixel-array-to-uiimage-in-swift

public struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

func imageFromARGB32Bitmap(pixels: UnsafeMutablePointer<PixelData>, width: Int, height: Int)-> UIImage {
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
    let bitsPerComponent:Int = 8
    let bitsPerPixel:Int = 32
    
    // assert(pixels.count == Int(width * height))
    
    // var data = pixels // Copy to mutable []
    let providerRef = CGDataProviderCreateWithCFData(
        NSData(bytes: pixels, length: width * height * sizeof(PixelData))
    )
    
    let cgim = CGImageCreate(
        width,
        height,
        bitsPerComponent,
        bitsPerPixel,
        width * Int(sizeof(PixelData)),
        rgbColorSpace,
        bitmapInfo,
        providerRef,
        nil,
        true,
        .RenderingIntentDefault
    )!
    return UIImage(CGImage: cgim)
}
