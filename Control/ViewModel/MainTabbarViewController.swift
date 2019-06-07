//
//  MainTabbarViewController.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/27.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MainTabbarViewController: ESTabBarItemContentView {
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        //highlightTextColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
        highlightTextColor = UIColor.black
        //iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        //highlightIconColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
        highlightIconColor = UIColor.black
        //        renderingMode = .alwaysOriginal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = 0.3 * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}
