//
//  PluginsViewController.swift
//  magic-majsoul
//
//  Created by 神崎H亚里亚 on 2019/5/27.
//  Copyright © 2019 moxcomic. All rights reserved.
//

import UIKit
import SwiftyJSON

class PluginsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        set_UI()
    }
    
    let cellId = "com.moxcomic.Plugins.ID"
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), style: .plain)
        view.tableFooterView = UIView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        view.delegate = self
        view.dataSource = self
        return view
    }()
}

extension PluginsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return run_plugins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        if let info = run_plugins[indexPath.row][0] as? JSON {
            cell.textLabel?.text = info["pluginName"].string
            cell.detailTextLabel?.text = info["desc"].string
        }
        if let filter = run_plugins[indexPath.row][1] as? JSON {
            let enable = UISwitch()
            enable.isOn = filter["enable"].bool ?? false
            enable.tag = indexPath.row
            enable.addTarget(self, action: #selector(changePluginEnable(sender:)), for: .valueChanged)
            cell.accessoryView = enable
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func changePluginEnable(sender: UISwitch) {
        guard let plugin = run_plugins[sender.tag][2] as? URL, var filter = run_plugins[sender.tag][1] as? JSON else {
            sender.isOn = true
            return
        }
        
        let path = plugin.appendingPathComponent("filter.json")
        
        if !FileManager.default.fileExists(atPath: path.path) {
            sender.isOn = true
        } else {
            filter["enable"].bool = sender.isOn
            run_plugins[sender.tag][1] = filter
            try? "\(filter)".write(to: path, atomically: true, encoding: .utf8)
        }
    }
}

extension PluginsViewController {
    func set_UI() {
        set_nav()
        set_tableView()
    }
    
    func set_nav() {
        navigationItem.title = "已安装插件"
    }
    
    func set_tableView() {
        view.addSubview(tableView)
    }
}
