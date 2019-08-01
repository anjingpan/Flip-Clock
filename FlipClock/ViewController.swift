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
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDate()
        startTimer()
    }
    
    // MARK: - UI
    func initView() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 1 / 255, alpha: 1)
        
        hourLabel = initFlipLabel({ (label) in
            label.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: 62 + label.bounds.height * 0.5)
        })
        
        minuteLabel = initFlipLabel { (label) in
            label.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: 78 + label.bounds.height * 1.5)
        }
    }
    
    func initFlipLabel(_ configuration: (_ label: FlipLabel) -> Void) -> FlipLabel {
        let label = FlipLabel()
        label.textColor = UIColor(red: 183 / 255, green: 184 / 255, blue: 185 / 255, alpha: 1)
        label.backgroundColor = UIColor(red: 24 / 255, green: 25 / 255, blue: 26 / 255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 120)
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 2 * 58, height: UIScreen.main.bounds.width - 2 * 58)
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

