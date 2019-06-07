//
//  LoggerViewController.swift
//  majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/30.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit

class LoggerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        logView.frame = view.bounds
        view.addSubview(logView)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showLog), userInfo: nil, repeats: true)
        //调用fire()会立即启动计时器
        timer!.fire()
    }
    
    @objc func showLog() {
        logView.text = logs.joined(separator: "\n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    var timer : Timer?
    
    lazy var logView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        return view
    }()
}
