//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by yl on 2019/8/5.
//  Copyright © 2019 anjing. All rights reserved.
//

import UIKit
import NotificationCenter

let kNormalHeight: CGFloat = 110
let kExpandHeight: CGFloat = 200

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: - Property
    fileprivate var hourLabel: FlipLabel!
    fileprivate var minuteLabel: FlipLabel!
    fileprivate var hourDividingView: UIView!
    fileprivate var minuteDividingView: UIView!
    
    fileprivate var timer: Timer?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDate()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let url = URL(string: "FlipClock://") else { return }
        self.extensionContext?.open(url, completionHandler: nil)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        preferredContentSize = activeDisplayMode == .compact ? CGSize(width: view.bounds.width, height: kNormalHeight) : CGSize(width: view.bounds.width, height: kExpandHeight)
        
        updateLabel()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - UI
    func initView() {
        view.backgroundColor = UIColor(r: 0, g: 0, b: 1)
        
        hourLabel = initFlipLabel()
        hourDividingView = initCenterDividingView(for: hourLabel)
        
        minuteLabel = initFlipLabel()
        minuteDividingView = initCenterDividingView(for: minuteLabel)
        
        updateLabel()
    }
    
    //Update Label
    func updateLabel() {
        [hourLabel, minuteLabel].forEach { (label) in
            let height: CGFloat = preferredContentSize.height == kNormalHeight ? 16 : 48
            label?.frame = CGRect(x: 0, y: 0, width: preferredContentSize.height - height, height: preferredContentSize.height - height)
            label?.font = UIFont.systemFont(ofSize: preferredContentSize.height == kNormalHeight ? 50 : 106)
            label?.layer.cornerRadius = preferredContentSize.height == kNormalHeight ? 10 : 20
        }
        
        [hourDividingView, minuteDividingView].forEach { (dividingView) in
            dividingView?.frame = CGRect(x: 0, y: 0, width: hourLabel.bounds.width, height: preferredContentSize.height == kNormalHeight ? 2 : 4)
            guard let center = dividingView?.superview?.center else { return }
            dividingView?.center = center
        }
        
        hourLabel.center = CGPoint(x: UIScreen.main.bounds.width * 0.5 - hourLabel.bounds.width * 0.5 - 8, y: preferredContentSize.height * 0.5)
        minuteLabel.center = CGPoint(x: UIScreen.main.bounds.width * 0.5 + minuteLabel.bounds.width * 0.5 + 8, y: preferredContentSize.height * 0.5)
    }
    
    func updateLabelCenter(screenWidth: CGFloat, screenHeight: CGFloat, isWillTransition: Bool = false) {
        
    }
    
    func initFlipLabel() -> FlipLabel {
        let label = FlipLabel()
        label.textColor = UIColor(r: 183, g: 184, b: 185)
        label.backgroundColor = UIColor(r: 24, g: 25, b: 26)
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.animationDuration = 1.5
        view.addSubview(label)

        return label
    }
    
    func initCenterDividingView(for label: FlipLabel) -> UIView {
        let view = UIView()
        view.backgroundColor = self.view.backgroundColor
        label.addSubview(view)
        return view
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

extension TodayViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateDate), userInfo: nil, repeats: true)
        guard let nextMinute = nextMinute() else { return }
        timer?.fireDate = nextMinute
    }
}
