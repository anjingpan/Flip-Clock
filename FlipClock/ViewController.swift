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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label = FlipLabel()
        label.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        label.center = view.center
        label.text = "21"
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .white
        label.backgroundColor = .green
        label.textAlignment = .center
        label.animationDuration = 10
        view.addSubview(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        label.text = "22"
    }
}

