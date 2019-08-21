//
//  ViewController.swift
//  FlipClock
//
//  Created by Jal on 2019/7/23.
//  Copyright © 2019 anjing. All rights reserved.
//

import UIKit

enum ClockStyle: String {
    case flip
    case digital
}

class ViewController: UIViewController {
    
    // MARK: - Property
    fileprivate var hourLabel: UILabel!
    fileprivate var minuteLabel: UILabel!
    
    fileprivate var timer: Timer?
    
    fileprivate var style: ClockStyle = .digital
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateStyle), name: .updateStyle, object: nil)
        
        for font in UIFont.familyNames {
            for name in UIFont.fontNames(forFamilyName: font) {
                print(name)
            }
        }
        
        setupData()
        initView()
        addAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDate()
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
        
        hourLabel.text = nil
        minuteLabel.text = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        //Will Transition Bounds height and width is still same as before
        updateLabelCenter(screenWidth: UIScreen.main.bounds.height, screenHeight: UIScreen.main.bounds.width, isWillTransition: true)
    }
    
    // MARK: - Data
    func setupData() {
        view.backgroundColor = SkinManager.shareInstance.color(with: kSkin_BackgroundColor)
        
        if let styleString = UserDefaults.key.style.stringValue , let clockStyle = ClockStyle(rawValue: styleString) {
            style = clockStyle
        }
        
        //Screen Always Display
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    // MARK: - UI
    func initView() {
        
        hourLabel = initFlipLabel{ (_) in
        }
        
        minuteLabel = initFlipLabel{ (_) in
        }
        
        updateLabelCenter(screenWidth: UIScreen.main.bounds.width, screenHeight: UIScreen.main.bounds.height)
    }
    
    //Update Label Center
    func updateLabelCenter(screenWidth: CGFloat, screenHeight: CGFloat, isWillTransition: Bool = false) {
        let orient = UIApplication.shared.statusBarOrientation
        
        if (orient.isPortrait && !isWillTransition) || (orient.isLandscape && isWillTransition) {
            hourLabel.center = CGPoint(x: screenWidth * 0.5, y: 62 + hourLabel.bounds.height * 0.5)
            minuteLabel.center = CGPoint(x: screenWidth * 0.5, y: 78 + minuteLabel.bounds.height * 1.5)
        } else {
            hourLabel.center = CGPoint(x: 62 + hourLabel.bounds.width * 0.5, y: screenHeight * 0.5)
            minuteLabel.center = CGPoint(x: 78 + hourLabel.bounds.width * 1.5, y: screenHeight * 0.5)
        }
        
    }
    
    func initFlipLabel(_ configuration: (_ label: UILabel) -> Void) -> UILabel {
        let label = style == .flip ? FlipLabel() : UILabel()
        label.textColor = SkinManager.shareInstance.color(with: kSkin_Label_TextColor)
        label.backgroundColor = SkinManager.shareInstance.color(with: kSkin_Label_BackgroundColor)
        label.font = UIFont.boldSystemFont(ofSize: 140)
        let width: CGFloat = UIApplication.shared.statusBarOrientation.isPortrait ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
        label.frame = CGRect(x: 0, y: 0, width: width - 2 * 58, height: width - 2 * 58)
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.textAlignment = .center
        view.addSubview(label)
        configuration(label)
        
        if style == .digital {
            label.font = UIFont(name: "Digital-7Mono", size: 140)
        } else if style == .flip , let flipLabel = label as? FlipLabel {
            flipLabel.animationDuration = 1.5
            let view = UIView(frame: CGRect(x: 0, y: 0, width: label.bounds.width, height: 4))
            view.center = label.center
            view.backgroundColor = self.view.backgroundColor
            flipLabel.addSubview(view)
            return flipLabel
        }
        return label
    }
    
    func addAction() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeView(_:)))
            swipeGesture.direction = direction
            view.addGestureRecognizer(swipeGesture)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }
    
    // MARK: - Selector
    @objc func updateStyle() {
        // userDefault has style and style don't match current
        guard let styleString = UserDefaults.key.style.stringValue , let clockStyle = ClockStyle(rawValue: styleString), style != clockStyle else { return }
        style = clockStyle
        [hourLabel, minuteLabel].forEach({ $0?.removeFromSuperview() })
        
        initView()
        updateDate()
    }
    
    @objc func swipeView(_ gesture: UISwipeGestureRecognizer) {
        let temStyle: ClockStyle = style == .digital ? .flip : .digital
        UserDefaults.key.style.set(temStyle.rawValue)
        NotificationCenter.default.post(name: .updateStyle, object: nil)
    }
    
    @objc func tapView() {
        SkinManager.shareInstance.skinType = SkinManager.shareInstance.skinType == .night ? .light : .night
        UserDefaults.key.skin.set(SkinManager.shareInstance.skinType.rawValue)
    }
    
    @objc func updateDate() {
        let date = Date()
        
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        let times = format.string(from: date).components(separatedBy: ":")
        hourLabel.text = times[0]
        minuteLabel.text = times[1]
    }
    
    //Get Next Minute to start Timer
    fileprivate func nextMinute() -> Date? {
        let date = Date()
        let calender = Calendar(identifier: .gregorian)
        let currentComponents = calender.dateComponents([.minute], from: date)
        
        guard let minute = currentComponents.minute else { return nil }
        var minuteCompents = DateComponents()
        minuteCompents.minute = (minute + 1) % 60

        return calender.nextDate(after: date, matching: minuteCompents, matchingPolicy: .nextTime)
    }
}

// MARK: - Timer
extension ViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateDate), userInfo: nil, repeats: true)
        guard let nextMinute = nextMinute() else { return }
        timer?.fireDate = nextMinute
    }
}

