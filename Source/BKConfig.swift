//
//  BKConfig.swift
//  BaseKit
//
//  Created by Harvey on 2019/6/11.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

#if os(iOS)

import Foundation

public class BKConfig {
    
    init() { }
    
    /// App Store 上的应用ID
    public var appId: String = "444934666"
    
    /// 自动更新设备型号列表
    public var autoUpdateDeviceModelList: Bool = false
}

#endif
