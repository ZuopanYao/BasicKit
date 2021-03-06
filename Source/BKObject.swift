//
//  BKObject.swift
//  BasicKit
//
//  Created by Harvey on 2019/6/6.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation

/// 归档基类，用于持久性保存模型
open class BKObject: NSObject & NSCoding {
    
    public var uuid: String { return uniqueID }
    
    public override init() {
        super.init()
    }
    
    fileprivate var uniqueID: String = String.bk.random(32, true)
    
    required public init?(coder aDecoder: NSCoder) {
        
        if let _uniqueID = aDecoder.decodeObject(forKey: "uniqueID") as? String {
            self.uniqueID = _uniqueID
        }
    }
    
    open func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.uniqueID, forKey: "uniqueID")
    }
}

extension Array where Element: BKObject {
    
    func exist(_ element: Element) -> Int? {
        
        for index in 0..<count {
            
            let localElement = self[index]
            if localElement.uuid == element.uuid {
                return index
            }
        }
        
        return nil
    }
    
    func archived() -> [Data] {
        
        var objects: [Data] = []
        forEach { (element) in
            
            let archiver = NSKeyedArchiver.archivedData(withRootObject: element)
            objects.append(archiver)
        }
        
        return objects
    }
}

extension Array where Element == Data {
    
    func unarchive<Base: NSObject & NSCoding>(_ base: Base.Type) -> [Base] {
        
        var objects: [Base] = []
        forEach { (element) in
            
            if  let object = NSKeyedUnarchiver.unarchiveObject(with: element),
                let toObject = object as? Base {
                objects.append(toObject)
            }
        }
        
        return objects
    }
}

public extension BasicKit where Base: BKObject {
    
    private var key: BK.Key { return BK.Key("\(Base.self)") }
    private static var key: BK.Key { return BK.Key("\(Base.self)") }
    
    static func read() -> [Base]? {
        
        if let data = BK.storager.array(key: key) as? [Data], data.count > 0 {
            return data.unarchive(Base.self)
        }
        
        return nil
    }
    
    static func readLast() -> Base? {
        return read()?.last
    }
    
    /// 持久性缓存
    func save() {
        
        var objects: [Base] = []
        if let elements =  BK.storager.array(key: key) as? [Data] {
            
            objects = elements.unarchive(Base.self)
            if let index = objects.exist(self.base) {
                objects.remove(at: index)
            }
        }
        
        objects.append(self.base)
        
        let archiver = objects.archived()
        BK.storager.set(archiver, key: key)
    }
    
    func remove() {
        
        if let elements = BK.storager.array(key: key) as? [Data] {
            
            var objects = elements.unarchive(Base.self)
            if let index = objects.exist(self.base) {
                
                objects.remove(at: index)
                let archiver = objects.archived()
                BK.storager.set(archiver, key: key)
            }
        }
    }
    
    /// 清除该模型数据
    static func clear() {
        BK.storager.remove(key: key)
    }
}

