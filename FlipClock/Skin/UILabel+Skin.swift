//
//  UILabel+Skin.swift
//  FlipClock
//
//  Created by yl on 2019/8/13.
//  Copyright © 2019 anjing. All rights reserved.
//

import UIKit

extension UILabel {
    private static let swizzleTextColor: Void = {
        swizzleMethodWithString(UILabel.self, form: kMethod_Label_TextColor, to: "AJ_setTextColor:")
    }()
    
    @objc func AJ_setTextColor(_ color: UIColor) {
        if let textColor = SkinManager.shareInstance.color(with: kSkin_Label_TextColor) {
            skinPickers[kMethod_Label_TextColor] = textColor
            self.AJ_setTextColor(textColor)
        }else {
            self.AJ_setTextColor(color)
        }
    }
    
     public static func labelSwizzle() {
        _ = swizzleTextColor
    }
}
