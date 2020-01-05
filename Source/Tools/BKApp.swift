//
//  BKApp.swift
//  BasicKit
//
//  Created by Harvey on 2019/6/5.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation
import StoreKit

extension BK.Key {
    
    static let firstEnterKey = BK.Key("BasicKit.App.First.Enter.Key")
}

public class BKApp {
    
    let info: [String: Any] = Bundle.main.infoDictionary!
    
    #if os(iOS)
    
    let app = UIApplication.shared
    
    /// 更新组件实例
    public let upgrade = BKUpgrade()
        
    /// 当版本更新后, 重置第一次进入App状态, 默认为false
    public var isAutoResetFirstEnterStatusWhenUpdated: Bool = false
   
    #endif

    /// 清除第一次进入App状态
    ///
    /// 此方法仅在开发测试时使用, 版本发布时请不要在任何代码中调用此方法
    ///
    public func clearFirstEnterStatus() {
        
        BK.storager.remove(key: BK.Key.firstEnterKey)
    }
    
    init() { }
    
    public struct Version {
        
        let base: BKApp
        init(_ base: BKApp) {
            self.base = base
        }
        
        public var short: String {
            return self.base.info["CFBundleShortVersionString"] as? String ?? ""
        }
        
        public var build: String {
             return self.base.info["CFBundleVersion"] as? String ?? short
        }
    }
    
    /// 版本号
    public lazy var version: BKApp.Version = { return BKApp.Version(self) }()
    
    /// Bundle Identifier
    public var bundleID: String {
        return self.info["CFBundleIdentifier"] as? String ?? ""
    }
    
    /// app名称
    public var name: String {
        return self.info["CFBundleName"] as? String ?? ""
    }
    
    /// app显示名称
    ///
    /// 安装后在桌面显示的名称，一般情况下和 name 是一样，除非手动设置了displayName
    ///
    public var displayName: String {
        return self.info["CFBundleDisplayName"] as? String ?? name
    }
    
    /// 第一次进入App
    ///
    public var isFirstEnter: Bool {
        
        var record = BK.storager.string(key: BK.Key.firstEnterKey)
        guard record.count > 0 else {
            
            BK.storager.set(version.short, key: BK.Key.firstEnterKey)
            return true
        }
        
        #if os(iOS)
        
        guard isAutoResetFirstEnterStatusWhenUpdated else {
            
            return false
        }
        
        #endif
        
        guard record.contains(version.short) else {
            
            record = record + "; \(version.short)"
            BK.storager.set(record, key: BK.Key.firstEnterKey)
            return true
        }
        
        return false
    }
    
    #if os(iOS)
    
    /// 显示App打分界面
    ///
    /// iOS 10.3 +
    public func showScoreView() {
        
        if #available(iOS 10.3, *) {
            
            SKStoreReviewController.requestReview()
        } else {
            BKLogv("showScoreView 不支持当前系统版本")
        }
    }
    
    public func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        
        app.open(url, options: options, completionHandler: completion)
    }
    
    public func open(_ url: String, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        
        open(URL(string: url)!, options: options, completionHandler: completion)
    }
    
    #endif
}
