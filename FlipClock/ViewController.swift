//
//  ViewController.swift
//  FlipClock
//
//  Created by Jal on 2019/7/23.
//  Copyright © 2019 anjing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Property
    fileprivate var hourLabel: FlipLabel!
    fileprivate var minuteLabel: FlipLabel!
    
    fileprivate var timer: Timer?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Screen Always Display
        UIApplication.shared.isIdleTimerDisabled = true
        
        initView()
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
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        //Will Transition Bounds height and width is still same as before
        updateLabelCenter(screenWidth: UIScreen.main.bounds.height, screenHeight: UIScreen.main.bounds.width, isWillTransition: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SkinManager.shareInstance.skinType = SkinManager.shareInstance.skinType == .night ? .light : .night
    }
    
    // MARK: - UI
    func initView() {
        view.backgroundColor = SkinManager.shareInstance.color(with: kSkin_BackgroundColor)
        
        hourLabel = initFlipLabel{ (label) in
        }
        
        minuteLabel = initFlipLabel { (label) in
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
    
    func initFlipLabel(_ configuration: (_ label: FlipLabel) -> Void) -> FlipLabel {
        let label = FlipLabel()
        label.textColor = SkinManager.shareInstance.color(with: kSkin_Label_TextColor)
        label.backgroundColor = SkinManager.shareInstance.color(with: kSkin_Label_BackgroundColor)
        label.font = UIFont.boldSystemFont(ofSize: 120)
        let width: CGFloat = UIApplication.shared.statusBarOrientation.isPortrait ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
        label.frame = CGRect(x: 0, y: 0, width: width - 2 * 58, height: width - 2 * 58)
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.animationDuration = 1.5
        view.addSubview(label)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: label.bounds.width, height: 4))
        view.center = label.center
        view.backgroundColor = self.view.backgroundColor
        label.addSubview(view)
        
        configuration(label)
        return label
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

