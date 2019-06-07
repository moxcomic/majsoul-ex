//
//  Extensions.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/22.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import Foundation
import CryptoSwift
import WebKit

extension UserDefaults {
    //应用第一次启动
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunched = "hasBeenLaunched"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunched)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunched)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
    //当前版本第一次启动
    static func isFirstLaunchOfNewVersion() -> Bool {
        //主程序版本号
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"] as! String
        
        //上次启动的版本号
        let hasBeenLaunchedOfNewVersion = "hasBeenLaunchedOfNewVersion"
        let lastLaunchVersion = UserDefaults.standard.string(forKey:
            hasBeenLaunchedOfNewVersion)
        
        //版本号比较
        let isFirstLaunchOfNewVersion = majorVersion != lastLaunchVersion
        if isFirstLaunchOfNewVersion {
            UserDefaults.standard.set(majorVersion, forKey:
                hasBeenLaunchedOfNewVersion)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunchOfNewVersion
    }
}

extension String {
    func isDirectory () -> Bool {
        var directoryExists = ObjCBool.init(false)
        let fileExists = FileManager.default.fileExists(atPath: self, isDirectory: &directoryExists)
        return fileExists && directoryExists.boolValue
    }
    
    func appendPath(path: String) -> String {
        return self.appending("/\(path)")
    }
    
    func lastPathComponent(isFile: Bool = true) -> String {
        if isFile {
            return URL(fileURLWithPath: self).lastPathComponent
        } else {
            return URL(string: self)?.lastPathComponent ?? ""
        }
    }
    
    func lastPathComponentWithoutExtension(isFile: Bool = true) -> String {
        if isFile {
            return URL(fileURLWithPath: self).lastPathComponent.replacingOccurrences(of: ".\(self.pathExtension())", with: "")
        } else {
            return URL(string: self)?.lastPathComponent.replacingOccurrences(of: ".\(self.pathExtension())", with: "") ?? ""
        }
    }
    
    func pathExtension(isFile: Bool = true) -> String {
        if isFile {
            return URL(fileURLWithPath: self).pathExtension
        } else {
            return URL(string: self)?.pathExtension ?? ""
        }
    }
}

extension Data {
    mutating func xorEncrypt() -> Data {
        for i in 0..<self.count {
            self[i] ^= 73
        }
        return self
    }
}

extension WKWebView {
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
