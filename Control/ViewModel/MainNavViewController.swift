//
//  MainNavViewController.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/27.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit

class MainNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - 重写Push方法
    /// 重写Push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        //interactivePopGestureRecognizer?.isEnabled = true
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - 自定义Nav需要重写这两个方法，否则设置状态栏不起作用
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
