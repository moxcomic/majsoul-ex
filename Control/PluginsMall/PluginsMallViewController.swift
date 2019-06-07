//
//  PluginsMallViewController.swift
//  majsoul
//
//  Created by 神崎H亚里亚 on 2019/6/1.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit
import WebKit

class PluginsMallViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = view.bounds
    }
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        //webConfiguration.userContentController.add(self, name: "log")
        let web = WKWebView(frame: .zero, configuration: webConfiguration)
        web.backgroundColor = .black
        web.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        web.isOpaque = false
        web.scrollView.bounces = false
        web.scrollView.contentInsetAdjustmentBehavior = .never
        web.load(URLRequest(url: URL(string: "https://static.hfi.me/mikutap/")!))
        //web.navigationDelegate = self
        //web.uiDelegate = self
        return web
    }()
}
