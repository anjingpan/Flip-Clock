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
    fileprivate var label: FlipLabel!
    var count = 20 {
        didSet {
            label.text = "\(count)"
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = FlipLabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        label.center = view.center
        label.text = "20"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        label.backgroundColor = .green
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        view.addSubview(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        count += 1
    }
}

