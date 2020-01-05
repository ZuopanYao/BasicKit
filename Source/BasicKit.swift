//
//  BasicKit.swift
//  BasicKit
//
//  Created by Harvey on 2019/6/5.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation

/// BasicKit
public struct BK {
    
    #if DEBUG
    /// CocoaPods集成或源码集成有效，
    /// 打包成framework后集成到项目，状态不正确，请不要使用此属性
    ///
    public static let isDebug: Bool = true
    #else
    /// CocoaPods集成或源码集成有效，
    /// 打包成framework后集成到项目，状态不正确，请不要使用此属性
    ///
    public static let isDebug: Bool = false
    #endif
    
    public struct Key {
        
        static let lang = Key("AppleLanguages")
        
        var value: String
        public init(_ value: String) {
            self.value = value
        }
    }
        
    public static let app = BKApp()
    public static let notify = BKNotify()
    public static let security = BKSecurity.shared
    
    /// 通过 BKLog 打印的
    public static let logger = BKConsole.shared
    
    #if os(iOS)
    
    public static let device = BKDevice()
    public static let screen = BKScreen()
    public static let network = BKNetwork()
    
    static let config = BKConfig()
    public static func config(_ configBlock: (BKConfig) -> ()) {
        
        configBlock(BK.config)
    }
    
    #endif
    
    /// 临时缓存管理
    public static let cacher = BKCacher.shared
    
    /// 持久性缓存管理
    public static let storager = BKStorage.shared
    
    static var path: String = {
        
        return Bundle(for: BKObject.self).bundlePath
    }()
    
    
    public static var document: String = {
       
        let fileManager = FileManager.default
        let path = "\(NSHomeDirectory())/BasicKit"
        
        var isFolder: ObjCBool = true
        if false == fileManager.fileExists(atPath: path, isDirectory: &isFolder) {
         
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
        
        return path
    }()
}

public struct BasicKit<Base> {
    
    var base: Base
    fileprivate init(_ base: Base) {
        self.base = base
    }    
}

public protocol BasicKitCompatible {
    
    associatedtype CompatibleType
    
    var bk: BasicKit<CompatibleType> { get }
    static var bk: BasicKit<CompatibleType>.Type { get }
}

public extension BasicKitCompatible {
    
    var bk: BasicKit<Self> {
        get { return BasicKit(self) }
    }

    static var bk: BasicKit<Self>.Type {
        get { return BasicKit<Self>.self }
    }
}

extension String: BasicKitCompatible { }
extension Data: BasicKitCompatible { }
extension BKObject: BasicKitCompatible { }
extension Int: BasicKitCompatible { }
extension Float: BasicKitCompatible { }
extension Double: BasicKitCompatible { }
extension Array: BasicKitCompatible { }
extension URL: BasicKitCompatible { }
extension BKType: BasicKitCompatible { }
