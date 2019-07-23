//
//  FlipLabel.swift
//  FilpClock
//
//  Created by yl on 2019/7/23.
//  Copyright © 2019 yl. All rights reserved.
//

import UIKit

class FlipLabel: UILabel {

    // MARK: - Property
    override var text: String? {
        willSet {
            //Set origin Text don't create snapshot
            guard let text = text, newValue != text else { return }
            
            let (topView, bottomView): (UIView, UIView) = createSnapShotViews()
            previousTextTopView = topView
            previousTextBottomView = bottomView
            addSubview(previousTextTopView)
            addSubview(previousTextBottomView)
        }
        
        //Set origin Text don't create snapshot
        didSet {
            guard let oldValue = oldValue, text != oldValue else { return }
            
            let (_ , bottomView): (UIView, UIView) = createSnapShotViews()
            nextTextBottomView = bottomView
            
            beiginAnimation()
        }
    }
    //Total Animation Duration , default: 1
    open var animationDuration: CFTimeInterval = 1 {
        didSet {
            topAnimationDuration = 0.5 * animationDuration
            bottomAnimationDuration = 0.1 * animationDuration
        }
    }
    
    fileprivate var topAnimationDuration: CFTimeInterval = 0.5
    fileprivate var bottomAnimationDuration: CFTimeInterval = 0.1
    
    fileprivate var nextTextBottomView: UIView!
    fileprivate var previousTextTopView: UIView!
    fileprivate var previousTextBottomView: UIView!
    
    // MARK: - Function
    func createSnapShotViews() -> (UIView, UIView) {
        
        //get snapshot image
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapShotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        let topView = createHalfSnapShotView(image: snapShotImage, origin: .zero)
        let bottomView = createHalfSnapShotView(image: snapShotImage, origin: CGPoint(x: 0, y: -snapShotImage.size.height * 0.5))
        bottomView.frame.origin.y = snapShotImage.size.height * 0.5
        return(topView, bottomView)
    }
    
    func createHalfSnapShotView(image: UIImage, origin: CGPoint) -> UIView {
        let halfSize = CGSize(width: image.size.width, height: image.size.height * 0.5)
        
        UIGraphicsBeginImageContextWithOptions(halfSize, false, 0)
        image.draw(at: origin)
        let halfImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let view = UIImageView(image: halfImage)
        return view
    }
}

// MARK: - Animation
extension FlipLabel {
    func beiginAnimation() {
        addTopShadowAnimation()
        addTopFlipAnimation()
        
        addBottomShadowAnimation()
    }
    
    func addTopShadowAnimation() {
        let topViewShadow = UIView(frame: previousTextTopView.bounds)
        topViewShadow.backgroundColor = .black
        topViewShadow.alpha = 0
        
        previousTextTopView.addSubview(topViewShadow)
        
        UIView.animate(withDuration: topAnimationDuration) {
            topViewShadow.alpha = 0.3
        }
    }
    
    func addTopFlipAnimation() {
        let topAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        
        previousTextTopView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        previousTextTopView.center = CGPoint(x: previousTextTopView.frame.width * 0.5, y: previousTextTopView.frame.height)
        
        topAnimation.duration = topAnimationDuration
        topAnimation.fromValue = 0
        topAnimation.toValue = Double.pi * 0.5
        topAnimation.delegate = self
        topAnimation.isRemovedOnCompletion = false
        topAnimation.setValue("topAnimation", forKey: "animationKey")
        previousTextTopView.layer.add(topAnimation, forKey: "topRotation")
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 400
        transform = CATransform3DRotate(transform, CGFloat.pi, 1, 0, 0)
        previousTextTopView.layer.transform = transform
    }
    
    func addBottomShadowAnimation() {
        
    }
}

extension FlipLabel: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
}
