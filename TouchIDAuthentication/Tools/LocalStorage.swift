//
//  LocalStorage.swift
//  TouchIDAuthentication
//
//  Created by Harvey on 2017/10/17.
//  Copyright © 2017年 Harvey. All rights reserved.
//

import Foundation

fileprivate let TouchIDLocalKey = "TouchIDLocalKey"

/// 管理指纹登陆用户，当前设计一台设备只能存在一个账号使用指纹登陆
class LocalStorage {
    
    static let shared = LocalStorage()
    
    private var userDefaults = UserDefaults.standard
    
    func save(account: String) {
        
        userDefaults.set(account, forKey: TouchIDLocalKey)
        userDefaults.synchronize()
    }
    
    func clear() {
        
        userDefaults.set(nil, forKey: TouchIDLocalKey)
        userDefaults.synchronize()
    }
    
    func getTouchIDAccount() -> String? {
        
        return userDefaults.object(forKey: TouchIDLocalKey) as? String
    }
}
