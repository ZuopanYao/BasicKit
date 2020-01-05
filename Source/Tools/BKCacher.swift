//
//  BKCacher.swift
//  BasicKit
//
//  Created by Harvey on 2018/5/9.
//  Copyright © 2018年 Harvey. All rights reserved.
//

import Foundation

/// 持久性数据缓存管理，先写到内存中，再写到磁盘中
public class BKStorage {
    
    public static let shared = BKCacher(.storage)
}

public class BKCacher {
    
    public enum Policy {
        
        /// 持久保存，先写到内存中，再写到磁盘中
        case storage
        
        /// 临时保存到内存中, 崩溃或重启数据丢失
        case cache
    }
    
    /// 临时数据高速缓存管理, 崩溃或重启数据丢失
    public static let shared = BKCacher(.cache)
    
    private let policy: Policy
    init(_ policy: Policy) { self.policy = policy }
    
    private let userDefault = UserDefaults.standard
    private var temporary: [String: Any?] = [:]
    
    public func setCodable<Base: Codable>(_ value: Base, key: BK.Key) {
        
        if let data = try? JSONEncoder().encode(value) {
            set(data, key: key)
        }
    }
    
    public func set(_ value: Any?, key: BK.Key) {
        
        if let _ = value {
            temporary.removeValue(forKey: key.value)
        }else {
            temporary.updateValue(value, forKey: key.value)
        }
        
        if policy == .storage {
            
            userDefault.set(value, forKey: key.value)
            userDefault.synchronize()
        }
    }
    
    public func remove(key: BK.Key) {
        
        temporary.removeValue(forKey: key.value)
        if policy == .storage {
            
            userDefault.removeObject(forKey: key.value)
            userDefault.synchronize()
        }
    }
    
    public func codable<T: Codable>(key: BK.Key, _ codable: T.Type) -> T? {
        
        if let data = data(key: key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    public func any(key: BK.Key) -> Any? {
        if let value = temporary[key.value] {
            return value
        }
        
        if policy == .storage {
            return userDefault.value(forKey: key.value)
        }
        
        return nil
    }
    
    public func any<T>(key: BK.Key, _ anyObject: T.Type) -> T? {
        
        return any(key: key) as? T
    }
    
    public func integer(key: BK.Key) -> Int {
        
        if let value = temporary[key.value] as? Int   {
            return value
        }
        
        if policy == .storage {
            return userDefault.integer(forKey: key.value)
        }
        
        return 0
    }
    
    public func float(key: BK.Key) -> Float {
        
        if let value = temporary[key.value] as? Float   {
            return value
        }
        
        if policy == .storage {
            return userDefault.float(forKey: key.value)
        }
        
        return 0.0
    }
    
    public func double(key: BK.Key) -> Double {
        
        if let value = temporary[key.value] as? Double   {
            return value
        }
        
        if policy == .storage {
            return userDefault.double(forKey: key.value)
        }
        
        return 0.0
    }
    
    public func url(key: BK.Key) -> URL? {
        
        if let value = temporary[key.value] as? URL   {
            return value
        }
        
        if policy == .storage {
            return userDefault.url(forKey: key.value)
        }
        
        return nil
    }
    
    public func bool(key: BK.Key) -> Bool {
        
        if let value = temporary[key.value] as? Bool   {
            return value
        }
        
        if policy == .storage {
            return userDefault.bool(forKey: key.value)
        }
        
        return false
    }
    
    public func string(key: BK.Key) -> String {
        
        if let value = temporary[key.value] as? String   {
            return value
        }
        
        if policy == .storage {
            return userDefault.string(forKey: key.value) ?? ""
        }
        
        return ""
    }
    
    public func array(key: BK.Key) -> [Any] {
        if let value = temporary[key.value] as? [Any]   {
            return value
        }
        
        if policy == .storage {
            return userDefault.array(forKey: key.value) ?? []
        }
        
        return []
    }
    
    public func stringArray(key: BK.Key) -> [String] {
        
        if let value = temporary[key.value] as? [String]   {
            return value
        }
        
        if policy == .storage {
            return userDefault.stringArray(forKey: key.value) ?? []
        }
        
        return []
    }
    
    public func dictionary(key: BK.Key) -> [String: Any] {
        
        if let value = temporary[key.value] as? [String: Any]   {
            return value
        }
        
        if policy == .storage {
            return userDefault.dictionary(forKey: key.value) ?? [:]
        }
        
        return [:]
    }
    
    public func data(key: BK.Key) -> Data? {
        
        if let value = temporary[key.value] as? Data   {
            return value
        }
        
        if policy == .storage {
            return userDefault.data(forKey: key.value)
        }
        
        return nil
    }
}
