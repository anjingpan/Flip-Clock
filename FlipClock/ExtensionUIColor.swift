//
//  ExtensionUIColor.swift
//  FlipClock
//
//  Created by yl on 2019/8/2.
//  Copyright © 2019 anjing. All rights reserved.
//
import Foundation
import UIKit

extension UIColor {
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    public convenience init(hex: UInt) {
        self.init(r: CGFloat(hex & 0xFF0000 >> 16),
                  g: CGFloat(hex & 0x00FF00 >> 8),
                  b: CGFloat(hex & 0x0000FF))
    }
    
    public convenience init(hexWithAlpha: UInt) {
        self.init(r: CGFloat(hexWithAlpha & 0xFF000000 >> 24),
                  g: CGFloat(hexWithAlpha & 0x00FF0000 >> 16),
                  b: CGFloat(hexWithAlpha & 0x0000FF00 >> 8),
                  a: CGFloat(hexWithAlpha & 0x000000FF) / 255)
    }
}
