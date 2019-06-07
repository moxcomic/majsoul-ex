//
//  AboutViewController.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/25.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        set_UI()
    }
}

extension AboutViewController {
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}

extension AboutViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return true
    }
}

extension AboutViewController {
    func set_UI() {
        set_nav()
        setInfo()
    }
    
    func set_nav() {
        navigationItem.title = "雀魂 X"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(back))
    }
    
    func setInfo() {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        textView.isEditable = false
        textView.textAlignment = .center
        let aboutString =
        """
        当前版本：beta测试版
        权限列表：
            - 网络权限
            - 定位权限：仅用于绕过iOS后台机制达到后台运行目的
        
        为确保《雀魂 X》正常运行，请允许弹出的所有权限，如点击拒绝请自行在系统设置内打开
        
        目前已内置插件有：
        【修改背景-默认】
        【修改点数显示板-默认】
        【修改麻将牌-默认】
        【一姬立绘修改-默认】
        【关闭实名认证-默认】
        【开启报菜名-默认】
        【解锁全人物-默认-只在主界面有效】//封号危险！请慎重选择！！！
        
        已知BUG（暂未解决）：
        1.显示Debug日志时会有卡顿（此项为临时输出，之后不会显示在此位置）
        2.部分时候声音会延迟播放或点击以下才有声音或者无声音
        3.部分时候在后台时会导致App被Kill，再次点击App时会闪退重载
        4.微博、微信等第三方登录暂时无法进行登录

        --------------------------
        解锁全人物插件第一次启动无效请使用悬浮球里的【清除缓存】功能或者手动重启游戏，使用游戏内的重启按钮无效
        
        警告：
        在您使用《雀魂 X》进行游戏时产生的一切后果，《雀魂 X》不对此承担任何责任！
        在您使用《雀魂 X》进行游戏时切勿将App切到后台，否则可能造成App被系统Kill！
        
        如果有任何的问题、建议以及BUG请按照以下联系方式进行反馈。
        
        开发者：神崎H亚里亚
        QQ:656469762
        QQ群：61012117
        """
        
//        let wx = UIImage(named: "wx")
//        let alipay = UIImage(named: "alipay")
//        let qq = UIImage(named: "qq")
//        let pp = "https://www.paypal.me/moxcomicus"
        
        textView.text = aboutString
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        textView.delegate = self
        view.addSubview(textView)
    }
    
}
