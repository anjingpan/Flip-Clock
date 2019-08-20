//
//  SkinConstant.swift
//  FlipClock
//
//  Created by yl on 2019/8/14.
//  Copyright © 2019 anjing. All rights reserved.
//

import Foundation

// MARK: - Notification Name
private let kNotification_Name_UpdateSkin = "Notification_Name_UpdateSkin"

// MARK: - Skin Config
let kSkin_BackgroundColor = "setBackgroundColor"
let kSkin_Label_BackgroundColor = "label" + kSkin_BackgroundColor
let kSkin_Label_TextColor = "setTextColor"

// MARK: - Method Config
let kMethod_BackgroundColor = "setBackgroundColor:"
let kMethod_Label_TextColor = "setTextColor:"


extension Notification.Name {
    public static let updateSkin = Notification.Name(kNotification_Name_UpdateSkin)
}
