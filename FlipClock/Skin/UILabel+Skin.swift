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
        self.AJ_setTextColor(color)
        
        guard let textColor = SkinManager.shareInstance.color(with: kSkin_Label_TextColor) else { return }
        skinPickers[kMethod_Label_TextColor] = textColor
    }
    
     public static func labelSwizzle() {
        _ = swizzleTextColor
    }
}
