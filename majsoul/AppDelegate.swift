//
//  AppDelegate.swift
//  majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/29.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit
import SVProgressHUD
import SSZipArchive
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var blockRotation: UIInterfaceOrientationMask = .landscapeRight {
        didSet{
            if blockRotation.contains(.portrait){
                //强制设置成竖屏
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }else{
                //强制设置成横屏
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
        }
    }
    
    var locationManager: CLLocationManager?//定位服务
    var isBackground = false//标志是否在后台运行
    var backgroundTask: UIBackgroundTaskIdentifier!//后台任务标志
    
    var tencentAuth: TencentOAuth!

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return blockRotation
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.requestAlwaysAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(SetLocationService(notification:)), name: NSNotification.Name("SetLocationService"), object: nil)
        
        if UserDefaults.isFirstLaunch() {
            print("首次启动...")
            print("写入默认配置文件...")
            SVProgressHUD.show(withStatus: "正在初始化插件目录...")
            try? FileManager.default.createDirectory(atPath: plugin_path, withIntermediateDirectories: true, attributes: nil)
            try? FileManager.default.createDirectory(atPath: cache_path, withIntermediateDirectories: true, attributes: nil)
            for plugin in firstLaunchCopyPlugins {
                SSZipArchive.unzipFile(atPath: plugin, toDestination: plugin_path, overwrite: true, password: nil, progressHandler: { (_, _, _, _) in
                    
                }) { (_, success, error) in
                    print("解压成功:\(plugin.lastPathComponentWithoutExtension())")
                }
            }
            SVProgressHUD.showSuccess(withStatus: "首次启动加载完成")
            SVProgressHUD.dismiss(withDelay: 2.5)
        }
        
        loadPlugins()
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = MainViewController.shared
        window?.makeKeyAndVisible()
        
        URLProtocol.registerClass(MajsoulProtocol.self)
        
        tencentAuth = TencentOAuth(appId: "101480027", andDelegate: self)//clientid 101480027  //101495990
        WXApi.registerApp("wxbcc5f71dfd993d5c") //wx2a0c2449cab74448  wxbcc5f71dfd993d5c
        WeiboSDK.registerApp("1610027480")//AppKey/client_id 399644784   22191242ac93f71da72492a63395bf40  2014052600006128
        WeiboSDK.enableDebugMode(true)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        })//这里是官方Demo的实现，用于当后台过期后的处理，实际中不会用到，但仍写出
        self.isBackground = true
        BackgroundKeepTimeTask()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        locationManager?.stopUpdatingLocation()
        isBackground = false
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("被调起:\(url)\nopt:\(options)")
        
        let urlKey: String = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
        
        if urlKey == "com.tencent.mqq" {
            // QQ 的回调
            return TencentOAuth.handleOpen(url)
        }
        
        if urlKey == "com.tencent.xin" {
            // 微信 的回调
            return  WXApi.handleOpen(url, delegate: self)
        }
        
        if urlKey == "com.sina.weibo" {
            // 新浪微博 的回调
            return WeiboSDK.handleOpen(url, delegate: self)
        }
        
        // 例如: 你的新浪微博的AppKey为: 123456789, 那么这个值就是: wb123456789
        if url.scheme == "URL Schemes" {
            // 新浪微博H5 的回调
            //return LDSinaShare.handle(url)
            print(url)
        }
        
        return true
    }
}

extension AppDelegate: WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        guard let res = response as? WBAuthorizeResponse else { return  }
        
        guard let uid = res.userID else { return  }
        guard let accessToken = res.accessToken else { return }
        
        let urlStr = "https://api.weibo.com/2/users/show.json?uid=\(uid)&access_token=\(accessToken)&source=1610027480"
        let url = URL(string: urlStr)
        do {
            //                    let responseStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            let dict = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            guard let dic = dict else {
                //获取授权信息异常
                return
            }
            print(dic)
        } catch {
            //获取授权信息异常
        }
    }
}

extension AppDelegate: WXApiDelegate {
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        // 这里是使用异步的方式来获取的
        let sendRes: SendAuthResp? = resp as? SendAuthResp
        let queue = DispatchQueue(label: "wechatLoginQueue")
        queue.async {
            print("async: \(Thread.current)")
            if let sd = sendRes {
                if sd.errCode == 0 {
                    
                    guard (sd.code) != nil else {
                        return
                    }
                    print("code:\(sd.code)")
                    // 第一步: 获取到code, 根据code去请求accessToken
                    self.requestAccessToken((sd.code)!)
                } else {
                    
                    DispatchQueue.main.async {
                        // 授权失败
                        print("微信登录授权失败...")
                    }
                }
            } else {
                
                DispatchQueue.main.async {
                    // 异常
                    print("微信登录授权异常...")
                }
            }
        }
    }
    
    private func requestAccessToken(_ code: String) {
        // 第二步: 请求accessToken
        let urlStr = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxbcc5f71dfd993d5c&secret=26bcbd2c53a214ffa452d8c2f64120d3&code=\(code)&grant_type=authorization_code"
        let url = URL(string: urlStr)
        do {
            //                    let responseStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            guard dic != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                    print("微信登录获取授权信息异常1...")
                }
                return
            }
            print("dic:\n\(dic)")
            guard dic!["access_token"] != nil else {
                DispatchQueue.main.async {
                    //获取授权信息异常
                    print("微信登录获取授权信息异常2...")
                }
                return
            }
            guard dic!["openid"] != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                    print("微信登录获取授权信息异常3...")
                }
                return
            }
            // 根据获取到的accessToken来请求用户信息
            self.requestUserInfo(dic!["access_token"]! as! String, openID: dic!["openid"]! as! String)
        } catch {
            DispatchQueue.main.async {
                // 获取授权信息异常
                print("微信登录获取授权信息异常4...")
            }
        }
    }
    
    private func requestUserInfo(_ accessToken: String, openID: String) {
        let urlStr = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openID)"
        let url = URL(string: urlStr)
        do {
            //                    let responseStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            guard dic != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                    print("微信登录获取授权信息异常5...")
                }
                return
            }
            if let dic = dic {
                // 这个字典(dic)内包含了我们所请求回的相关用户信息
            }
        } catch {
            DispatchQueue.main.async {
                // 获取授权信息异常
                print("微信登录获取授权信息异常6...")
            }
        }
    }
}

extension AppDelegate: TencentLoginDelegate, TencentSessionDelegate {
    func tencentDidLogin() {
        tencentAuth.getUserInfo()
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        print("未登录...")
    }
    
    func tencentDidNotNetWork() {
        print("网络异常...")
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        if response.retCode == 0 {
            if let res = response.jsonResponse {
                print("QQ登录-> json\n\(res)")
                if let uid = self.tencentAuth.getUserOpenID() {
                    // 获取uid
                    print("QQ登录-> uid:\(uid)")
                    if let webView = (window?.rootViewController as? MainViewController)?.webView {
                        print("accessToken:\(tencentAuth.accessToken)")
                        print("openId:\(tencentAuth.openId)")
//                        webView.evaluateJavaScript("self.location.href='?code=\(tencentAuth.accessToken!)&state=xdsfdl3'") { (rsp, err) in
//                            if err != nil {
//                                print("err:\(err?.localizedDescription)")
//                            } else {
//                                print("rsp:\(rsp)")
//                            }
//                        }
                        let code = tencentAuth.getServerSideCode()
                        print("code is:\(code ?? "")")
                        let urlString = "http://www.majsoul.com/0/?code=\(code ?? "")&state=xdsfdl3"
                        var request = URLRequest(url: URL(string: urlString)!)
                        request.addValue("www.majsoul.com", forHTTPHeaderField: "Host")
                        request.addValue(urlString, forHTTPHeaderField: "Referer")
                        request.addValue("close", forHTTPHeaderField: "Connection")
                        webView.load(request)
                        
                        //webView.load(URLRequest(url: URL(string: "https://majsoul.union-game.com/0/?code=\(uid)&state=xdsfdl3")!))
                        //http://www.majsoul.com/0?code=023D418B968F394A99AA687D85B4FFDD&state=xdsfdl3
                        //http://www.majsoul.com/0/?code=023D418B968F394A99AA687D85B4FFDD&state=xdsfdl3
                        //https://majsoul.union-game.com/0/?code=023D418B968F394A99AA687D85B4FFDD&state=xdsfdl3
                        //http://www.majsoul.com/0?code=8CF221D5BD4AB4622E1E0B645BE0C5DB&state=xdsfdl3
                        //A9A2D35FEC065E6A7D40141595E1FD84
                    }
                }
                
                if let name = res["nickname"] {
                    // 获取nickname
                    print("QQ登录-> name:\(name)")
                }
                
                if let sex = res["gender"] {
                    // 获取性别
                    print("QQ登录-> sex:\(sex)")
                }
                
                if let img = res["figureurl_qq_2"] {
                    // 获取头像
                    print("QQ登录-> img:\(img)")
                }
            }
        } else {
            // 获取授权信息异常
            print("QQ登录授权异常...")
        }
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    @objc func SetLocationService(notification: NSNotification) {
        if(notification.object == nil)
        {
            return
        }
        let setSwitch = notification.object as! Bool
        if(setSwitch)
        {
            locationManager?.startUpdatingLocation()
        }
        else
        {
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func BackgroundKeepTimeTask()
    {
        print("进入后台进程")
        DispatchQueue.global(qos: .default).async {
            self.locationManager?.distanceFilter = kCLDistanceFilterNone//任何运动均接受
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters//定位精度设置为最差（减少耗电）
            var theadCount = 0//循环计数器，这里用作时间计数
            var isShowNotice = false//是否显示掉线通知
            while(self.isBackground)
            {
                //print("isBackgroud:\(self.isBackground)")
                Thread.sleep(forTimeInterval: 1)//休眠
                theadCount += 1
                if(theadCount > 60)//每60秒启动一次定位刷新后台在线时间
                {
                    print("开始位置服务")
                    self.locationManager?.startUpdatingLocation()
                    Thread.sleep(forTimeInterval: 1)//定位休眠1秒
                    print("停止位置服务")
                    self.locationManager?.stopUpdatingLocation()
                    theadCount = 0
                }
                DispatchQueue.main.async {
                    let timeRemaining = UIApplication.shared.backgroundTimeRemaining
                    //print("Background Time Remaining = %.02f Seconds", timeRemaining)//显示系统允许程序后台在线时间，如果保持后台成功，这里后台时间会被刷新为180s
                    if(timeRemaining < 60 && !isShowNotice) {
                        print("后台保持在线失败，请检查定位设置并重新运行客户端")
                        isShowNotice = true
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case CLAuthorizationStatus.authorizedAlways:
            break
        case CLAuthorizationStatus.authorizedWhenInUse:
            print("定位服务未正确设置\n客户端保持后台功能需要调用系统的位置服务\n请设置NSUCC定位服务权限为始终")
            break
        case CLAuthorizationStatus.denied:
            print("定位服务被禁止\n客户端保持后台功能需要调用系统的位置服务\n请到设置中打开位置服务")
            break
        case CLAuthorizationStatus.notDetermined:
            break
        case CLAuthorizationStatus.restricted:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("位置改变，做点儿事情来更新后台时间")
        let loc = locations.last
        let latitudeMe = loc?.coordinate.latitude
        let longitudeMe = loc?.coordinate.longitude
        print("\(latitudeMe)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("进入方位测定")
        let oldRad =  -manager.heading!.trueHeading * .pi / 180.0
        let newRad =  -newHeading.trueHeading * .pi / 180.0
    }
}

