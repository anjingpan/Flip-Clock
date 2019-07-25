//
//  FlipLabel.swift
//  FilpClock
//
//  Created by yl on 2019/7/23.
//  Copyright © 2019 yl. All rights reserved.
//

import UIKit

let kAnimation = "animation"

enum AnimationName: String {
    case topText = "topText"
    case bottomText = "bottomText"
    case bottomShadow = "bottomShadow"
}

class FlipLabel: UILabel {

    // MARK: - Property
    override var text: String? {
        willSet {
            //Set same Text don't create snapshot
            guard let text = text, newValue != text else { return }
            
            let (topView, bottomView): (UIView, UIView) = createSnapShotViews()
            previousTextTopView = topView
            previousTextBottomView = bottomView
            //shadow should inside View
            previousTextBottomView.clipsToBounds = true
        }
        
        didSet {
            //Set same Text don't create snapshot
            guard let oldValue = oldValue, text != oldValue else { return }
            
            let (_ , bottomView): (UIView, UIView) = createSnapShotViews()
            nextTextBottomView = bottomView
            
            //after next bottom view snapshot addSubView
            addSubview(previousTextTopView)
            addSubview(previousTextBottomView)
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
    fileprivate func createSnapShotViews() -> (UIView, UIView) {
        
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
    
    fileprivate func createHalfSnapShotView(image: UIImage, origin: CGPoint) -> UIView {
        let halfSize = CGSize(width: image.size.width, height: image.size.height * 0.5)
        
        UIGraphicsBeginImageContextWithOptions(halfSize, false, 0)
        image.draw(at: origin)
        let halfImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let view = UIImageView(image: halfImage)
        view.layer.allowsEdgeAntialiasing = true
        return view
    }
}

// MARK: - Animation
extension FlipLabel {
    fileprivate func beiginAnimation() {
        addTopShadowAnimation()
        addTopFlipAnimation()
        
        addBottomShadowAnimation()
    }
    
    fileprivate func addTopShadowAnimation() {
        let topViewShadow = UIView(frame: previousTextTopView.bounds)
        topViewShadow.backgroundColor = .black
        topViewShadow.alpha = 0
        
        previousTextTopView.addSubview(topViewShadow)
        
        UIView.animate(withDuration: topAnimationDuration) {
            topViewShadow.alpha = 0.3
        }
    }
    
    fileprivate func addTopFlipAnimation() {
        let topAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        
        previousTextTopView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        previousTextTopView.center = CGPoint(x: previousTextTopView.frame.width * 0.5, y: previousTextTopView.frame.height)
        
        topAnimation.duration = topAnimationDuration
        topAnimation.fromValue = 0
        topAnimation.toValue = Double.pi * 0.5
        topAnimation.delegate = self
        topAnimation.isRemovedOnCompletion = false
        topAnimation.setValue( AnimationName.topText.rawValue , forKey: kAnimation)
        previousTextTopView.layer.add(topAnimation, forKey: "topRotation")
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 400
        transform = CATransform3DRotate(transform, CGFloat.pi, 1, 0, 0)
        previousTextTopView.layer.transform = transform
    }
    
    fileprivate func addBottomShadowAnimation() {
        let bottomLayer = CAShapeLayer()
        let frame = CGRect(x: 0, y: 0, width: previousTextBottomView.bounds.width * 2, height: previousTextBottomView.bounds.height * 2)
        previousTextBottomView.layer.addSublayer(bottomLayer)
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.close()
        
        let middlePath = UIBezierPath()
        middlePath.move(to: .zero)
        middlePath.addLine(to: CGPoint(x: frame.width, y: 0))
        middlePath.addLine(to: CGPoint(x: frame.width, y: 0))
        middlePath.addLine(to: CGPoint(x: frame.width, y: frame.height / 3))
        middlePath.close()
        
        let endPath = UIBezierPath()
        endPath.move(to: .zero)
        endPath.addLine(to: CGPoint(x: frame.width, y: 0))
        endPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        endPath.addLine(to: CGPoint(x: 0, y: frame.height))
        endPath.close()
        
        bottomLayer.path = path.cgPath
        bottomLayer.opacity = 0.2
        bottomLayer.fillColor = UIColor.black.cgColor
        bottomLayer.frame = frame
        
        let animation = CAKeyframeAnimation(keyPath: "path")
        animation.values = [path.cgPath, middlePath.cgPath, endPath.cgPath]
        animation.keyTimes = [0, 0.6 , 1]
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeIn), CAMediaTimingFunction(name: .linear), CAMediaTimingFunction(name: .linear)]
        animation.duration = topAnimationDuration + bottomAnimationDuration
        animation.isRemovedOnCompletion = false
        
        bottomLayer.add(animation, forKey: AnimationName.bottomShadow.rawValue)
    }
    
    fileprivate func addBottomTitleAnimation() {
        addSubview(nextTextBottomView)
        nextTextBottomView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        nextTextBottomView.center = CGPoint(x: nextTextBottomView.frame.width * 0.5, y: nextTextBottomView.frame.height)

        let bottomAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        bottomAnimation.duration = bottomAnimationDuration
        bottomAnimation.fromValue = Double.pi * 0.5
        bottomAnimation.toValue = 0
        bottomAnimation.delegate = self
        //keep tovalue state
        bottomAnimation.fillMode = .forwards
        bottomAnimation.isRemovedOnCompletion = false
        bottomAnimation.setValue(AnimationName.bottomText.rawValue, forKey: kAnimation)
        nextTextBottomView.layer.add(bottomAnimation, forKey: "bottomRotation")

        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -350
        transform = CATransform3DRotate(transform, CGFloat.pi * 0.5, 1, 0, 0)
        nextTextBottomView.layer.transform = transform
    }
    
    func stopAnimation() {
        var array = [previousTextTopView, previousTextBottomView, nextTextBottomView]
        for i in 0..<array.count {
            guard let view = array[i] else { return }
            view.layer.removeAllAnimations()
            view.removeFromSuperview()
            array[i] = nil
        }
    }
}

extension FlipLabel: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim.value(forKey: kAnimation) as? String == AnimationName.topText.rawValue {
            addBottomTitleAnimation()
        }else if anim.value(forKey: kAnimation) as? String == AnimationName.bottomText.rawValue {
            var array = [previousTextTopView, previousTextBottomView, nextTextBottomView]
            
            for i in 0..<array.count {
                guard let view = array[i] else { return }
                view.removeFromSuperview()
                array[i] = nil
            }
        }
    }
}
