//
//  MainViewController.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/21.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit
import WebKit
import NSURLProtocolWebKitSupport
import SnapKit
import SDWebImage
import RASFloatingBall
import EasyAnimation
import SwiftyJSON
import GCDWebServer
import SVProgressHUD

class MainViewController: UIViewController {
    static let shared = MainViewController()
    
    let server = GCDWebServer()
    let webUploader = GCDWebUploader(uploadDirectory: plugin_path)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var options: [String: Any] = [:]
        options[GCDWebServerOption_Port] = 8080
        //BindToLocalhost set to YES means HTTP server won't accept any connections outside of your device
        options[GCDWebServerOption_BindToLocalhost] = true
        options[GCDWebServerOption_BonjourName] = "localhost"
        //below parameter NO makes sure the server runs until iOS stops it in the background
        options[GCDWebServerOption_AutomaticallySuspendInBackground] = false
        //the parameter 2.0 below is in seconds. It is defined as double so you need to have x.x type of a number as the parameter
        options[GCDWebServerOption_ConnectedStateCoalescingInterval] = 2.0
        
        //try? server.start(options: options)
        //print("server start:\(server.serverURL?.absoluteString ?? "")")
        //SVProgressHUD.showSuccess(withStatus: "server start on:\(server.serverURL?.absoluteString ?? "")")
        
//        webUploader.addHandler(forMethod: "GET", path: "/", request: GCDWebServerRequest.self) { (request) -> GCDWebServerResponse? in
//            print("GCDWebRequest URL:\(request.url.absoluteString)")
//            return GCDWebServerResponse(redirect: URL(string: "https://majsoul.union-game.com/0/")!, permanent: true)
//        }
//        try? webUploader.start(options: options)
//        print("server start:\(webUploader.serverURL?.absoluteString ?? "")")
//        SVProgressHUD.showSuccess(withStatus: "server start on:\(webUploader.serverURL?.absoluteString ?? "")")
        
        URLProtocol.wk_registerScheme("http")
        URLProtocol.wk_registerScheme("https")
        
        loadWebView()
    }
    
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return true
//    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .all
    }
    
    lazy var loadingView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        view.backgroundColor = .black
        view.contentMode = .center
        return view
    }()
    
    var webView: WKWebView!
    
    lazy var floatingBall: RASFloatingBall = {
        let ball = RASFloatingBall(frame: CGRect(x: 25, y: 0, width: 40, height: 40))
        ball.layer.cornerRadius = 20
        ball.layer.masksToBounds = true
        ball.setContent(UIImage(named: "floatingBall")!, contentType: .image)
        ball.isAutoCloseEdge = true
        return ball
    }()
}

extension MainViewController {
    func loadWebView() {
        if webView != nil {
            webView.removeFromSuperview()
            webView = nil
        }
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController.add(self, name: "log")
        //webConfiguration.userContentController.add(self, name: "alert")
        webConfiguration.userContentController.add(self, name: "setloadrate")
        webConfiguration.userContentController.add(self, name: "getappversion")
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.backgroundColor = .black
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.isOpaque = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.load(URLRequest(url: URL(string: "https://majsoul.union-game.com/0/")!))
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        view.addSubview(webView)
    }
}

extension MainViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载...")
        loadJavaScript()
        UIApplication.shared.keyWindow?.addSubview(loadingView)
        UIApplication.shared.keyWindow?.bringSubviewToFront(loadingView)
        let path = Bundle.main.path(forResource: "loading_3", ofType:"gif")
        let file = FileHandle(forReadingAtPath: path!)
        let data = file?.readDataToEndOfFile()
        file?.closeFile()
        loadingView.image = UIImage.sd_image(withGIFData: data)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("开始回调...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成...")
        if !webView.isLoading {
            UIView.animate(withDuration: 1.2, animations: {
                self.loadingView.alpha = 0
            }, completion: { (success) in
                self.loadingView.removeFromSuperview()
                
                self.floatingBall.autoEdgeRetractDuration(2.5, edgeRetractConfigHander: { () -> RASEdgeRetractConfig in
                    return RASEdgeRetractConfig(edgeRetractOffset: CGPoint(x: 20, y: 20), edgeRetractAlpha: 0.7)
                })
                
                self.floatingBall.clickHandler = { _ in
                    self.present(UINavigationController(rootViewController: ControlViewController()), animated: true, completion: nil)
                }
                self.view.addSubview(self.floatingBall)
            })
        }
    }
    
    func loadJavaScript() {
        webView.configuration.userContentController.removeAllUserScripts()
        let _console_log = """
        console.log = (function(oriLogFunc){
        return function(str)
        {
        window.webkit.messageHandlers.log.postMessage(str);
        oriLogFunc.call(console,str);
        }
        })(console.log);
        """
        webView.configuration.userContentController.addUserScript(WKUserScript(source: _console_log, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        
//        let _alert = """
//        alert = (function(oriLogFunc){
//        return function(str)
//        {
//        window.webkit.messageHandlers.alert.postMessage(str);
//        oriLogFunc.call(console,str);
//        }
//        })(alert);
//        """
//        webView.configuration.userContentController.addUserScript(WKUserScript(source: _alert, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        
//        let _init_js = try? String(contentsOfFile: Bundle.main.path(forResource: "init", ofType: "js")!)
//        webView.configuration.userContentController.addUserScript(WKUserScript(source: _init_js!, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        
        for plugin in run_plugins {
            if let filter = plugin[1] as? JSON {
                if let enable = filter["enable"].bool, let script = filter["script"].bool {
                    if enable && script {
                        if let env = plugin[2] as? URL {
                            let scriptPath = env.appendingPathComponent("script/script.js")
                            if FileManager.default.fileExists(atPath: scriptPath.path) {
                                if let soucre = try? String(contentsOf: scriptPath) {
                                    //webView.configuration.userContentController.addUserScript(WKUserScript(source: soucre, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false))
                                    self.runJavaScript(env: env.lastPathComponent, scriptString: soucre)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func runJavaScript(env: String, scriptString: String) {
        DispatchQueue.main.async {
            self.webView.evaluateJavaScript(scriptString) { response, error in
                if error != nil {
                    //print(" error: \(error!.localizedDescription)")
                    if error!.localizedDescription != "JavaScript execution returned a result of an unsupported type" {
                        self.runJavaScript(env: env, scriptString: scriptString)
                    }
                } else {
                    print("\(env) response:\(response!)")
                    return
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败...")
        handleError(error: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }
    
    func handleError(error: Error) {
        print("error")
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print("收到响应后...")
//    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("发送请求前...")
        print(navigationAction.request.url)
        if let urlString = navigationAction.request.url?.absoluteString {
            if urlString.contains("weixin.qq.com") {
                let alertController = UIAlertController(title: "提示", message: "暂未支持微信登录,开发安排中...", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in

                }))
                present(alertController, animated: true)
                decisionHandler(.cancel)
                return

//                let req = SendAuthReq()
//                req.scope = "snsapi_userinfo"
//                req.state = "xdsfdl1"
//
//                WXApi.send(req)
//
//                decisionHandler(.cancel)
//                return
            }
            else if urlString.contains("qq.com") {
                let appDel = UIApplication.shared.delegate as! AppDelegate
                // 需要获取的用户信息
                let permissions = [kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
                appDel.tencentAuth.authMode = kAuthModeServerSideCode
                appDel.tencentAuth.authorize(permissions)
                decisionHandler(.cancel)
                return
                
//                let alertController = UIAlertController(title: "提示", message: "暂未支持QQ登录,开发安排中...", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in
//
//                }))
//                present(alertController, animated: true)
//                decisionHandler(.cancel)
//                return
            } else if urlString.contains("weibo.com") {
                let request = WBAuthorizeRequest()
                request.scope = "all"
                // 此字段的内容可自定义, 在请求成功后会原样返回, 可用于校验或者区分登录来源
                //        request.userInfo = ["": ""]
//                request.redirectURI = "https://majsoul.union-game.com/0/"
//
//                WeiboSDK.send(request)
//
//                decisionHandler(.cancel)
//                return

                let alertController = UIAlertController(title: "提示", message: "暂未支持微博登录,开发安排中...", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in

                }))
                present(alertController, animated: true)
                decisionHandler(.cancel)
                return
            } else if urlString.contains("alipay.com") {
                let alertController = UIAlertController(title: "提示", message: "出于安全考虑,第三方客户端不支持充值。", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in

                }))
                present(alertController, animated: true)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("alert PanelWithMessage")
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in
            completionHandler()
        }))
        getTopVC()?.present(alertController, animated: true)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("alert ConfirmPanelWithMessage")
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            completionHandler(false)
        }))

        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in
            completionHandler(true)
        }))
        getTopVC()?.present(alertController, animated: true)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("alert defaultText")
        let alertController = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.text = defaultText
        })

        alertController.addAction(UIAlertAction(title: "完成", style: .default, handler: { action in
            completionHandler(alertController.textFields![0].text ?? "")
        }))
        getTopVC()?.present(alertController, animated: true)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("JS Log(name:\(message.name), msg:\(message.body))")
        
//        if "\(message.name)" == "alert" {
//            let alertController = UIAlertController(title: "提示", message: "\(message.body)", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { action in
//            }))
//            getTopVC()?.present(alertController, animated: true)
//        }
        
        addLog("\(message.body)", target: "JS Log (\(message.name))")
    }
}
