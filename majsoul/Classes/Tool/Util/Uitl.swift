//
//  Uitl.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/22.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import Foundation
import SwiftyJSON
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Regex

let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height

var run_plugins: [[Any]] = [[Any]]()

func loadPlugins() {
    print("开始加载插件...")
    //modify = (UserDefaults.standard.array(forKey: "modify")! as! [[String: Any]])
    run_plugins.removeAll()
    do {
        let plugins = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: plugin_path), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        for plugin in plugins {
            if plugin.path.isDirectory() {
                let info = plugin.appendingPathComponent("info.json")
                let filter = plugin.appendingPathComponent("filter.json")
                do {
                    let infoData = try Data(contentsOf: info)
                    let filterData = try Data(contentsOf: filter)
                    let infoJSON = try JSON(data: infoData)
                    let filterJSON = try JSON(data: filterData)
                    run_plugins.append(
                        [
                            infoJSON,
                            filterJSON,
                            plugin
                        ])
                    addLog("加载插件【\(infoJSON["pluginName"].string ?? "")】 开发者:\(infoJSON["author"].string ?? "")", target: "雀魂X")
                    print("加载插件:\(infoJSON["pluginName"].string ?? "")  作者:\(infoJSON["author"].string ?? "")")
                } catch {
                    print("解析插件失败:\(plugin)")
                }
            }
        }
    } catch {
        print("检索插件目录失败...")
    }
    print("加载插件完成...")
}

let firstLaunchCopyPlugins: [String] =
[
    Bundle.main.path(forResource: "修改背景", ofType: ".majplugin")!,
    Bundle.main.path(forResource: "修改点数显示板", ofType: ".majplugin")!,
    Bundle.main.path(forResource: "修改麻将牌", ofType: ".majplugin")!,
    Bundle.main.path(forResource: "一姬立绘修改", ofType: ".majplugin")!,
    Bundle.main.path(forResource: "关闭实名认证", ofType: ".majplugin")!,
    Bundle.main.path(forResource: "开启报菜名", ofType: ".majplugin")!,
    Bundle.main.path(forResource: "解锁全人物", ofType: ".majplugin")!
]

let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let plugin_path = document.appending("/Plugins")
let cache_path = document.appending("/Caches")

var logs = [String]()

func addLog(_ log: String, target: String) {
    let date = Date()
    let zone = TimeZone.current
    let interval = zone.secondsFromGMT(for: date)
    let localeDate = date.addingTimeInterval(TimeInterval(interval))
    logs.append("\(localeDate):【\(target)】 --> \(log)")
}

let disposeBag = DisposeBag()
func show_input_alert(title: String?, keyboardType: UIKeyboardType = .default, placeholder: String = "输入数据", currentVC: UIViewController, confirmHandler: ((String) -> ())?, cancelHandler: ((UIAlertAction) -> ())?) {
    let inputText = UITextView()
    let alertController = UIAlertController.init(title: nil, message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
        print("输入了:\(inputText.text!)")
        confirmHandler?(inputText.text!)
    }))
    alertController.addAction(UIAlertAction(title: "取消", style: .destructive, handler: { (action) in
        print("取消输入...")
        cancelHandler?(action)
    }))
    
    //    alertController.addTextField { (textField) in
    //        inputText = textField
    //        inputText.placeholder = placeholder
    //        inputText.keyboardType = keyboardType
    //    }
    
    inputText.backgroundColor = .clear
    alertController.view.addSubview(inputText)
    let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenW, height: 44))
    toolBar.backgroundColor = UIColor.white
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let btn = UIBarButtonItem(title: "完成", style: .done, target: nil, action: nil)
    btn.rx.tap.bind {
        inputText.resignFirstResponder()
    }.disposed(by: disposeBag)
    toolBar.items = [space, btn]
    inputText.inputAccessoryView = toolBar
    
    inputText.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.top.left.equalToSuperview().offset(8)
        make.right.equalToSuperview().offset(-8)
        make.bottom.equalToSuperview().offset(-52)
    }
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).takeUntil(alertController.rx.deallocated).subscribe() {
        if let keyboardSize = ($0.element?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                inputText.contentInset.bottom = 52 + keyboardSize.height + UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            })
        }
    }.disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).takeUntil(alertController.rx.deallocated).subscribe() {
        if (($0.element?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                inputText.contentInset.bottom = 0
            })
        }
    }.disposed(by: disposeBag)
    
    currentVC.present(alertController, animated: true, completion: nil)
}

func getTopVC() -> (UIViewController?) {
    var window = UIApplication.shared.keyWindow
    //是否为当前显示的window
    if window?.windowLevel != UIWindow.Level.normal {
        let windows = UIApplication.shared.windows
        for  windowTemp in windows{
            if windowTemp.windowLevel == UIWindow.Level.normal {
                window = windowTemp
                break
            }
        }
    }
    let vc = window?.rootViewController
    return getTopVC(withCurrentVC: vc)
}
///根据控制器获取 顶层控制器
func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
    if VC == nil {
        print("找不到顶层控制器")
        return nil
    }
    if let presentVC = VC?.presentedViewController {
        //modal出来的 控制器
        return getTopVC(withCurrentVC: presentVC)
    }else if let tabVC = VC as? UITabBarController {
        // tabBar 的跟控制器
        if let selectVC = tabVC.selectedViewController {
            return getTopVC(withCurrentVC: selectVC)
        }
        return nil
    } else if let naiVC = VC as? UINavigationController {
        // 控制器是 nav
        return getTopVC(withCurrentVC:naiVC.visibleViewController)
    } else {
        // 返回顶控制器
        return VC
    }
}

func getReplaceResource(request: URLRequest) -> [Any]? {
    for item in run_plugins {
        guard
            let urlString = request.url?.absoluteString,
            let filter = item[1] as? JSON,
            let plugin = item[2] as? URL
            else {
                continue
        }
        
        guard
            let enable = filter["enable"].bool,
            let replace = filter["replace"].array
            else {
                continue
        }
        
        if enable {
            for regex in replace {
                guard let from = regex["from"].string, let xor = regex["xor"].bool, let to = regex["to"].string else {
                    continue
                }
                
                guard let matchURL = try? Regex(string: from, options: [.ignoreCase]) else {
                    continue
                }
                
                if matchURL.matches(urlString) {
                    var path = plugin.appendingPathComponent("res/\(to)")
                    
                    if let match = try? Regex(string: "\\$(\\d+)", options: [.ignoreCase]) {
                        if match.matches(to) {
                            path = plugin.appendingPathComponent("res/\(to)")
                            
                            for item in match.allMatches(in: to) {
                                if let indexString = item.captures[0] {
                                    if let index = Int(indexString) {
                                        //print("match captures: $\(index)")
                                        if let capturesString = matchURL.firstMatch(in: urlString)?.captures[index - 1] {
                                            path = URL(fileURLWithPath: path.path.replacingOccurrences(of: "$\(index)", with: capturesString))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    return [path, xor]
                }
            }
        }
    }
    return nil
}
