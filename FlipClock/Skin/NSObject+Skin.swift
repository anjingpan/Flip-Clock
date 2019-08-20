//
//  NSObject+Skin.swift
//  FlipClock
//
//  Created by yl on 2019/8/14.
//  Copyright © 2019 anjing. All rights reserved.
//

import UIKit

private var kSkinPicker = "SkinPicker"

extension NSObject {
    // MARK: - Property
    typealias SkinPickers = [String: UIColor]
    
    var skinPickers: SkinPickers {
        get {
            if let skinPickers = objc_getAssociatedObject(self, &kSkinPicker) as? SkinPickers {
                return skinPickers
            }
            
            let newPicker = SkinPickers()
            objc_setAssociatedObject(self, &kSkinPicker, newPicker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newPicker
        }
        
        set {
            objc_setAssociatedObject(self, &kSkinPicker, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue.isEmpty == false {
                NotificationCenter.default.removeObserver(self)
                NotificationCenter.default.addObserver(self, selector: #selector(updateSkin), name: .updateSkin, object: nil)
            }
        }
    }
    
    // MARK: - Function
    @objc func updateSkin() {
        skinPickers.forEach { (selectorString, color) in
            let selector = Selector(selectorString)
            guard responds(to: selector) else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.perform(selector, with: color)
            })
        }
    }
}
