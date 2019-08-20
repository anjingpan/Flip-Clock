//
//  ExtensionNotification.swift
//  FlipClock
//
//  Created by yl on 2019/8/20.
//  Copyright © 2019 anjing. All rights reserved.
//

import Foundation

private let kNotification_Name_UpdateStyle = "Notification_Name_UpdateStyle"

extension Notification.Name {
    public static let updateStyle = Notification.Name(kNotification_Name_UpdateStyle)
}
