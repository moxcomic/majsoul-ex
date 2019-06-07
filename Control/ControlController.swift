//
//  ControlViewController.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/27.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import WebKit
import SVProgressHUD

class ControlViewController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let v1 = MainNavViewController(rootViewController: PluginsViewController())
        let v2 = MainNavViewController(rootViewController: PluginsMallViewController())
        let v3 = MainNavViewController(rootViewController: UIViewController())
        let v4 =  MainNavViewController(rootViewController: AboutViewController())
        let v5 =  MainNavViewController(rootViewController: LoggerViewController())
        v1.tabBarItem = ESTabBarItem(MainTabbarViewController(), title: "已安装插件", image: UIImage(named: "tabbar_product"), selectedImage: UIImage(named: "tabbar_product"))
        v2.tabBarItem = ESTabBarItem(MainTabbarViewController(), title: "插件商城", image: UIImage(named: "tabbar_toolbox"), selectedImage: UIImage(named: "tabbar_toolbox"))
        v3.tabBarItem = ESTabBarItem(MainTabbarViewController(), title: "设置", image: UIImage(named: "tabbar_settings"), selectedImage: UIImage(named: "tabbar_settings"))
        v4.tabBarItem = ESTabBarItem(MainTabbarViewController(), title: "关于", image: UIImage(named: "tabbar_settings"), selectedImage: UIImage(named: "tabbar_settings"))
        v5.tabBarItem = ESTabBarItem(MainTabbarViewController(), title: "日志", image: UIImage(named: "tabbar_settings"), selectedImage: UIImage(named: "tabbar_settings"))
        viewControllers = [v1, v2, v3, v4, v5]
        
        navigationItem.title = "雀魂 X"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(back))
        let reloadGameBtn = UIBarButtonItem(title: "清除缓存", style: .done, target: self, action: #selector(reloadGame))
        let creditBtn = UIBarButtonItem(title: "支持开发者", style: .done, target: self, action: #selector(credit))
        let runJavaScriptBtn = UIBarButtonItem(title: "JavaScript", style: .done, target: self, action: #selector(runJavaScript))
        navigationItem.rightBarButtonItems = [reloadGameBtn, runJavaScriptBtn, creditBtn]
    }
    
    @objc func runJavaScript() {
        show_input_alert(title: nil, currentVC: self, confirmHandler: { (input) in
            MainViewController.shared.webView.evaluateJavaScript(input, completionHandler: nil)
        }, cancelHandler: nil)
    }
    
    @objc func credit() {
        //navigationController?.pushViewController(CreditViewController(), animated: true)
        UIApplication.shared.open(URL(string: "https://afdian.net/@moxcomic/plan")!)
    }
    
    @objc func reloadGame() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date) {
            print("清除缓存完成,正在重启游戏")
            SVProgressHUD.showSuccess(withStatus: "清除完成,正在重启游戏,如游戏未正常重启请手动重启游戏！")
            SVProgressHUD.dismiss(withDelay: 1.5)
            MainViewController.shared.loadWebView()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}
