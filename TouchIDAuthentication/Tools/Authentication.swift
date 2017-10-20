//
//  Authentication.swift
//  TouchIDAuthentication
//
//  Created by Harvey on 2017/10/17.
//  Copyright © 2017年 Harvey. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class Authentication {
    
    static let shared = Authentication()
    
    private var context: LAContext?
    private var isAvailable: Bool = false
    
    private init() {
        
        canEvaluatePolicy()
    }
    
    private  func canEvaluatePolicy() {
        
        context = nil;
        context = LAContext()
        
        var error: NSError?
        isAvailable = context!.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if  isAvailable {
            
            print("Touch ID is available")
        }else {
            
            print("Touch ID is not available:\(error!)")
        }
    }
    
    func evaluate(reason: String, completed: @escaping (_ isSuccess: Bool)->())  {
    
        guard isAvailable else {
            
            completed(false)
            return
        }
        
        context = nil
        context = LAContext()
        
        context!.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            (success, error) in
            
            if success {
                
                completed(true)
            }else {
                
                completed(false)
                print("\(error!)")
            }
        }
    }
}
