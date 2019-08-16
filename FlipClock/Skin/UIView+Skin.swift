//
//  UIView+Skin.swift
//  FlipClock
//
//  Created by yl on 2019/8/15.
//  Copyright © 2019 anjing. All rights reserved.
//

import UIKit

extension UIView {
    private static let swizzleBackgroundColor: Void = {
        swizzleMethodWithString(UIView.self, form: kMethod_BackgroundColor, to: "AJ_setBackgroundColor:")
    }()
    
    @objc func AJ_setBackgroundColor(_ color: UIColor) {
        if let _ = self as? UILabel {
            setPicker(with: kMethod_BackgroundColor, skinKey: kSkin_Label_BackgroundColor, originColor: color)
        }else {
            setPicker(with: kMethod_BackgroundColor, skinKey: kSkin_BackgroundColor, originColor: color)
        }
    }
    
    func setPicker(with key: String, skinKey: String, originColor: UIColor) {
        if let color = SkinManager.shareInstance.color(with: skinKey) {
            skinPickers[key] = color
            AJ_setBackgroundColor(color)
        }else {
            AJ_setBackgroundColor(originColor)
        }
    }
    
    public static func swizzle() {
        _ = swizzleBackgroundColor
    }
}
