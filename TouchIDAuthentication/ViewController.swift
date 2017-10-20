//
//  ViewController.swift
//  TouchIDAuthentication
//
//  Created by Harvey on 2017/10/17.
//  Copyright © 2017年 Harvey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var accountInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var touchIDBtn: UIButton!
    @IBOutlet weak var normalBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = LocalStorage.shared.getTouchIDAccount() { // 判断是否有账号开启了指纹登陆
            
            touchIDBtn.isHidden = false
            
            accountInput.isHidden = true
            passwordInput.isHidden = true
            normalBtn.isHidden = true
        }else {
            
            touchIDBtn.isHidden = true
            
            accountInput.isHidden = false
            passwordInput.isHidden = false
            normalBtn.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func normalLogin () {
    
        self.accountInput.resignFirstResponder()
        self.passwordInput.resignFirstResponder()
        
        guard let _ = accountInput.text, let _ = passwordInput.text else{
            
            return
        }
        
        // =========================================
        // 1、用户名和密码检验（长度限制、包含特殊字符等）
        // 2、与服务器通讯验证用户信息
        //  ........
        // ========================================
        
        showDetail(account: accountInput.text!)
    }
    
    @IBAction func touchIDLogin () {
        
        Authentication.shared.evaluate(reason: "指纹验证登陆") { (isSuccess) in
            
            guard isSuccess else {
                
                return
            }
            
            // 指纹验证通过
            self.showDetail(account: LocalStorage.shared.getTouchIDAccount()!)
        }
    }
    
    func showDetail(account: String) {
        
        guard let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            
            return
        }
        
        detail.account = account
        DispatchQueue.main.async {
            
            self.navigationController?.show(detail, sender: self)
        }
    }
}

