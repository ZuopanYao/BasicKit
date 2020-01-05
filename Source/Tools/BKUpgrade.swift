//
//  BKUpgrade.swift
//  BaseKit
//
//
//  Created by Harvey on 19/06/11.
//  Copyright (c) 2019年 Harvey. All rights reserved.
//

#if os(iOS)

import UIKit
import Alamofire

/// 检测App Store上是否有更新版本

public class BKUpgrade {
    
    init() { }

    public class Model {
        
        /// 新版本号
        public var version: String = ""
        
        /// 更新描述
        public var notes: String = ""
        
        /// 更新地址
        public var url: String = ""
        var minimumOsVersion: String = ""
    }
    
    private let lookupURL = "https://itunes.apple.com/lookup?id="
    
    /// 检测是否有新的版本
    public func check(callback: @escaping ((_ element: BKUpgrade.Model?) -> Void)){

        let url = lookupURL + BK.config.appId
        request(url, method: .post).responseJSON { (response) in

            if let error = response.error {
                
                BKLogv(error)
                callback(nil)
                return
            }
            
            guard let info = response.value as? [String: Any] else {
                
                callback(nil)
                return
            }
            
            guard let count = info["resultCount"] as? Int, count > 0 else {
            
                BKLog("App Store 上未发现此App: \(BK.config.appId) 未上架或已下架")
                callback(nil)
                return
            }
            
            guard let elements = info["results"] as? [[String: Any]], elements.count > 0 else {
                
                callback(nil)
                return
            }
            
            let element = elements.first!
            let model = BKUpgrade.Model()
            model.notes = element["releaseNotes"] as? String ?? ""
            model.version = element["version"] as? String ?? ""
            model.url = element["trackViewUrl"] as? String ?? ""
            model.minimumOsVersion = element["minimumOsVersion"] as? String ?? ""

            if model.version != BK.app.version.short,
                BK.device.os.version.bk.value.float >= model.minimumOsVersion.bk.value.float {
                
                callback(model)
            }else {
                
                callback(nil)
            }
        }
    }
}

#endif
