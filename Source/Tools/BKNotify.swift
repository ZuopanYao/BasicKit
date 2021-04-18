//
//  BKNotify.swift
//  BasicKit
//
//  Created by Harvey on 2020/1/5.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public class BKNotify {
    
    public struct Name {
        
        fileprivate let rawValue: String
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    private let notification = NotificationCenter.default
    
    public func remove(observer: Any) {
        notification.removeObserver(observer)
    }
    
    public func remove(observer: Any,  name: BKNotify.Name, object: Any? = nil) {
        
        remove(observer: observer, name: Notification.Name(name.rawValue), object: object)
    }
    
    public func remove(observer: Any,  name: Notification.Name, object: Any? = nil) {
        
        notification.removeObserver(observer, name: name, object: object)
    }
    
    public func post(name: BKNotify.Name, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        post(name: Notification.Name(name.rawValue), object: object, userInfo: userInfo)
    }
    
    public func post(name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        notification.post(name: name, object: object, userInfo: userInfo)
    }
    
    public func addObserver(name: BKNotify.Name, object: Any? = nil, queue: OperationQueue? = nil, usingblock: @escaping (Notification) -> Void) {
        
        addObserver(name: Notification.Name(name.rawValue), object: object, queue: queue, usingblock: usingblock)
    }
    
    public func addObserver(name: NSNotification.Name, object: Any? = nil, queue: OperationQueue? = nil, usingblock: @escaping (Notification) -> Void) {
        
        _ = notification.addObserver(forName: name, object: object, queue: queue, using: usingblock)
    }
    
    public func addObserver(_ observer: Any, selector: Selector, name: BKNotify.Name, object: Any? = nil) {
        addObserver(observer, selector: selector, name: Notification.Name(name.rawValue), object: object)
    }
    
    public func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name, object: Any? = nil) {
        notification.addObserver(observer, selector: selector, name: name, object: object)
    }
}
