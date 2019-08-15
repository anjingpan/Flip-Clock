//
//  Swizzle.swift
//  FlipClock
//
//  Created by yl on 2019/8/13.
//  Copyright © 2019 anjing. All rights reserved.
//

import Foundation

public func swizzleMethod(_ originClass: AnyClass, from origin: Selector, to swizzled: Selector, isClassMethod: Bool = false) {
    var swizzleClass: AnyClass = originClass
    
    if isClassMethod {
        guard let metaClass = object_getClass(originClass) else { return }
        swizzleClass = metaClass
    }
    
    guard let originMethod = class_getInstanceMethod(swizzleClass, origin),
        let swizzledMethod = class_getInstanceMethod(swizzleClass, swizzled) else { return }
    
    if class_addMethod(swizzleClass, origin, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
        class_replaceMethod(swizzleClass, swizzled, method_getImplementation(originMethod), method_getTypeEncoding(originMethod))
    }else {
        method_exchangeImplementations(originMethod, swizzledMethod)
    }
}

public func swizzleMethodWithString(_ originClass: AnyClass, form originString: String, to swizzledString: String, isClassMethod: Bool = false) {
    swizzleMethod(originClass, from: Selector(originString), to: Selector(swizzledString), isClassMethod: isClassMethod)
}

