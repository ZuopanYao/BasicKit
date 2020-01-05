//
//  BKSecurityHelper.swift
//  CertCheck
//
//  Created by Harvey on 2019/8/24.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation

public class BKSecurity {
    
    static let shared = BKSecurity()
    public var config: (Algorithm: BKSecurityCore.Algorithm, key: String, iv: String)? = nil

    lazy var factor: BKSecurityCore.Factor = {
        
        return BKSecurityCore.Factor(key: config!.key, iv: config!.iv)
    }()

    lazy var algorithm: BKSecurityCore.Algorithm = {

        return config!.Algorithm
    }()
}

extension BasicKit where Base == String {
    
    /// BKSecurity
    public func encrypt(_ encoding: String.Encoding = .utf8) -> String? {
        
        if BKSecurity.shared.config == nil {
             fatalError("不能使用安全加密，因为没有配置: BK.security.config is nil")
        }
        return BKSecurityCore.encrypt(base, factor: BKSecurity.shared.factor, algorithm: BKSecurity.shared.algorithm, encoding)
    }
    
    /// BKSecurity
    public func decrypt(_ encoding: String.Encoding = .utf8) -> String? {
        
        if BKSecurity.shared.config == nil {
                    fatalError("不能使用安全解密，因为没有配置: BK.security.config is nil")
               }
        return BKSecurityCore.decrypt(base, factor: BKSecurity.shared.factor, algorithm: BKSecurity.shared.algorithm, encoding)
    }
}
