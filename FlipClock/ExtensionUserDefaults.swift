//
//  ExtensionUserDefaults.swift
//  FlipClock
//
//  Created by yl on 2019/8/20.
//  Copyright © 2019 anjing. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum key: String, UserDefaultSettable {
        case style
        case skin
    }
}

public protocol UserDefaultSettable {
    var uniqueKey: String { get }
}

extension UserDefaultSettable where Self: RawRepresentable, Self.RawValue == String {
    // MARK: - Any
    public func set(_ value: Any?) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var value: Any? {
        return UserDefaults.standard.value(forKey: uniqueKey)
    }
    
    // MARK: - String
    public var stringValue: String? {
        return value as? String
    }
    
    // MARK: - Bool
    public func set(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var boolValue: Bool {
        return UserDefaults.standard.bool(forKey: uniqueKey)
    }
    
    // MARK: - Int
    public func set(_ value: Int) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var integerValue: Int {
        return UserDefaults.standard.integer(forKey: uniqueKey)
    }
    
    // MARK: - Double
    public func set(_ value: Double) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var doubleValue: Double {
        return UserDefaults.standard.double(forKey: uniqueKey)
    }
    
    // MARK: - Float
    public func set(_ value: Float) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var floatValue: Float {
        return UserDefaults.standard.float(forKey: uniqueKey)
    }
    
    // MARK: - URL
    public func set(_ value: URL?) {
        UserDefaults.standard.set(value, forKey: uniqueKey)
    }
    public var urlValue: URL? {
        return UserDefaults.standard.url(forKey: uniqueKey)
    }
    
    public var uniqueKey: String {
        return rawValue
    }
    
    public func remove() {
        UserDefaults.standard.removeObject(forKey: uniqueKey)
    }
}
