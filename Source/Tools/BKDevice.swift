//
//  BKDevice.swift
//  BasicKit
//
//  Created by Harvey on 2019/6/5.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

#if os(iOS)

import Foundation
import UIKit
import AdSupport
import SystemConfiguration.CaptiveNetwork
import KeychainAccess
import Alamofire

public class BKDevice {
    
    let device = UIDevice.current
    let key = "BasicKit.Device.Key.\(BK.app.bundleID)"
    
    init() {
        
        device.isBatteryMonitoringEnabled = true
        
        if BK.config.autoUpdateDeviceModelList {
            updateDeviceModelList()
        }
    }
    
    func updateDeviceModelList() {
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 8) {
            
            let url = "https://raw.githubusercontent.com/ZuopanYao/BasicKit/master/BasicKit/Resources/BKDeviceModel.plist"
            
            let destination: DownloadRequest.DownloadFileDestination =  { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                
                return (URL(string: "file://\(BK.document)/BKDeviceModel.plist")!, .removePreviousFile)
            }
            
            download(url, method: HTTPMethod.post, to: destination)
        }
    }
    
    /// 判断屏幕是否是刘海屏
    ///
    /// PhoneX、iPhoneXR、iPhoneXs、iPhoneXs Max等,
    /// 要在主线程中调用
    ///
    /// Returns
    /// - true: 是刘海屏
    /// - false: 不是刘海屏
    ///
    public lazy var isNotchScreen: Bool = {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return false
        }
        
        let size = UIScreen.main.bounds.size
        let notchValue: Int = Int(size.width/size.height * 100)
        
        if 216 == notchValue || 46 == notchValue {
            
            return true
        }
        
        return false
    }()
    
    /// 设备名称
    /// e.g. "My iPhone"
    public var name: String {
        
        return device.name
    }
    
    /// 设备类型
    /// e.g. "iPhone", "iPod touch"
    public var type: String {
        
        return device.model
    }
    
    /// 设备型号
    /// e.g. "iPhone XS Max"
    public lazy var model: String = {
        
        var lenght: Int = 18
        var machine: [CChar] = []
        let pointer =  "hw.machine".cString(using: String.Encoding.utf8)
        sysctlbyname(pointer, &machine, &lenght, nil, 0)
        
        var path = "\(BK.path)/BKDeviceModel.plist"
        let downloadPath = "\(BK.document)/BKDeviceModel.plist"
        if FileManager.default.fileExists(atPath: downloadPath) {
            
            path = downloadPath
        }
        
        let modelTable = NSDictionary(contentsOfFile: path) as? [String: String] ?? [:]
        let _model = String(cString: machine)
        
        return modelTable[_model] ?? _model
    }()
    
    /// true: 当前设备为iPad设备
    public var isPad: Bool {
        
        return device.userInterfaceIdiom == .pad
    }
    
    public struct OS {
        
        let base: BKDevice
        init(_ base: BKDevice) {
            self.base = base
        }
        
        /// 系统名称
        public var name: String {
            
            return base.device.systemName
        }
        
        /// 系统版本
        public var version: String {
            
            return base.device.systemVersion
        }
        
        /// 系统语言
        public var lang: String {
            
            return BK.storager.stringArray(key: BK.Key.lang)[0]
        }
    }
    
    /// 系统
    public lazy var os: BKDevice.OS = {
        
        return BKDevice.OS(self)
    }()
    
    /// 广告标示符, 如果用户关闭了广告跟踪则返回nil
    public var idfa: String? {
        
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return nil
    }
    
    /// 设备UUID, 不同应用不一样, 同一个应用(bundle ID不变时)即使卸载后重新安装也是一样的
    public lazy var uuid: String = {
        
        let keychain = Keychain(service: key)
        guard let value = keychain[key] else {
            
            let uuid = NSUUID().uuidString
            try? keychain.set(uuid, key: key)
            return uuid
        }
        
        return value
    }()
    
    /// wifi名称, iOS12+ 需要申请证书才可以获取到，否则为空
    ///
    /// 按下 command 键, 再点击链接, 可在本地 Documentation 打开
    /// @see https://developer.apple.com/documentation/systemconfiguration/1614126-cncopycurrentnetworkinfo
    ///
    public lazy var wifiName: String = {
        
        guard let interfaces = CFBridgingRetain(CNCopySupportedInterfaces()) else {
            
            return ""
        }
        
        let pointerInterfaceName = CFArrayGetValueAtIndex(unsafeBitCast(interfaces, to: CFArray.self), 0)
        let interfaceName = unsafeBitCast(pointerInterfaceName, to: CFString.self)
        guard let currentNetworkInfo = CFBridgingRetain(CNCopyCurrentNetworkInfo(interfaceName)) else {
            
            return ""
        }
        
        let keySSID = unsafeBitCast(kCNNetworkInfoKeySSID, to: UnsafeRawPointer.self)
        let pointerSSID: UnsafeRawPointer = CFDictionaryGetValue(unsafeBitCast(currentNetworkInfo, to: CFDictionary.self), keySSID)
        
        return String(utf8String: pointerSSID.assumingMemoryBound(to: CChar.self)) ?? ""
    }()
    
    public struct Orientation {
        
        let base: BKDevice
        init(_ base: BKDevice) {
            self.base = base
        }
        
        public var isPortrait: Bool {
            
            return self.base.device.orientation.isPortrait
        }
        
        public var isLandscape: Bool {
            
            return self.base.device.orientation.isLandscape
        }
        
        public var isFlat: Bool {
            
            return self.base.device.orientation.isFlat
        }
        
        public var isValidInterfaceOrientation: Bool {
            
            return self.base.device.orientation.isValidInterfaceOrientation
        }
    }
    
    /// 设备方向
    public lazy var orientation: BKDevice.Orientation = {
        
        return BKDevice.Orientation(self)
    }()
    
    public struct Battery {
        
        let base: BKDevice
        init(_ base: BKDevice) {
            self.base = base
        }
        
        /// 剩余电量
        ///
        /// 0 .. 1.0
        /// -1.0 if UIDeviceBatteryState.unknown
        public var level: Float {
            
            return self.base.device.batteryLevel
        }
    }
    
    /// 电池
    public lazy var battery: BKDevice.Battery = {
        
        return BKDevice.Battery(self)
    }()
}

#endif
