//
//  DetailViewController.swift
//  TouchIDAuthentication
//
//  Created by Harvey on 2017/10/17.
//  Copyright © 2017年 Harvey. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var account: String!
    
    lazy var datas: [String] = {
       
        return [self.account, "GG", "20"]
    }()
    
    lazy var cellTitle: [String] = {
        return ["账号", "性别", "年龄"]
    }()
    
    @objc func touchIDSwitchOnStatus(sender: UISwitch) {
        
        if sender.isOn {
            
            enableTouchID(sender: sender)
        }else {
            
            disableTouchID(sender: sender)
        }
        
        print(sender.isOn)
    }
    
    func enableTouchID(sender: UISwitch) {
        
        Authentication.shared.evaluate(reason: "开启指纹登陆", completed: { (isSuccess) in
            
            guard isSuccess else {
                
                DispatchQueue.main.async {
                    
                    sender.setOn(false, animated: true)
                }
                return
            }
            
            // 记录下账号信息,实际开发中可能需要保存更多的信息，需另外设计，当前只保存账号
            LocalStorage.shared.save(account: self.datas.first!)
            let alert = UIAlertController(title: "[\(self.datas.first!)]已开启指纹登陆", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(cancel)
            
            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func disableTouchID(sender: UISwitch) {
        
        Authentication.shared.evaluate(reason: "关闭指纹登陆", completed: { (isSuccess) in
            
            guard isSuccess else {
                
                DispatchQueue.main.async {
                    
                    sender.setOn(true, animated: true)
                }
                return
            }
            
            LocalStorage.shared.clear() // 删除账号记录
            let alert = UIAlertController(title: "[\(self.datas.first!)]已关闭指纹登陆", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(cancel)
            
            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.datas.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouchIDCell")!
            let touchIDSwitch = cell.viewWithTag(21) as! UISwitch
            touchIDSwitch.addTarget(self, action: #selector(touchIDSwitchOnStatus(sender:)), for: .valueChanged)
            
            if let localAccount = LocalStorage.shared.getTouchIDAccount(), localAccount == self.datas.first! {
                
                touchIDSwitch.isOn = true
            }else {
                touchIDSwitch.isOn = false
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID")!
        let label1 = cell.viewWithTag(10) as! UILabel
        label1.text = self.cellTitle[indexPath.row]
        
        let label2 = cell.viewWithTag(11) as! UILabel
        label2.text = self.datas[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.datas.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
}
