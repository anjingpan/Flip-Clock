//
//  SkinManager.swift
//  FlipClock
//
//  Created by yl on 2019/8/13.
//  Copyright © 2019 anjing. All rights reserved.
//

import UIKit

enum SkinType: String {
    case night
    case light
}

class SkinManager: NSObject {
    
    // MARK: - Property
    static let shareInstance: SkinManager = SkinManager()
    
    fileprivate var skinConfigDictionary: [String: String]?
    
    open var skinType: SkinType = .night {
        didSet {
            getSkinConfig()
            NotificationCenter.default.post(name: .updateSkin, object: nil)
        }
    }
    
    // MARK: - Life Cycle
    override init() {
        super.init()
        UIView.swizzle()
        UILabel.labelSwizzle()
    }
    
    // MARK: - Function
    func color(with keyString: String) -> UIColor? {
        guard let config = skinConfigDictionary, let hexString = config[keyString] else { return nil }
        return UIColor(hexString: hexString)
    }
    
    private func getSkinConfig() {
        var pathString: String?
        switch skinType {
        case .night:
            pathString = Bundle.main.path(forResource: "SkinNightConfig", ofType: "json")
        case .light:
            pathString = Bundle.main.path(forResource: "SkinLightConfig", ofType: "json")
        }
        
        do {
            guard let path = pathString else { return }
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            skinConfigDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
}
