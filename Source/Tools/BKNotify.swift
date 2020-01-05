//
//  BKNotify.swift
//  BaseKit
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
    
    public func remove(observer: Any,  name: BKNotify.Name? = nil, object: Any? = nil) {
        
        if name == nil, object == nil {
            
            notification.removeObserver(observer)
            return
        }
        
        guard let _ = name else {
            
            notification.removeObserver(observer, name: nil, object: object)
            return
        }
        notification.removeObserver(observer, name: Notification.Name(name!.rawValue), object: object)
    }
    
    public func post(name: BKNotify.Name, object: Any? = nil) {
        notification.post(name: Notification.Name(name.rawValue), object: object)
    }
    
    public func addObserver(name: BKNotify.Name, object: Any? = nil, queue: OperationQueue? = nil, usingblock: @escaping (Notification) -> Void) {
        
        _ = notification.addObserver(forName: Notification.Name(name.rawValue), object: object, queue: queue, using: usingblock)
    }
    
    public func addObserver(_ observer: Any, selector: Selector, name: BKNotify.Name, object: Any? = nil) {
        notification.addObserver(observer, selector: selector, name: Notification.Name(name.rawValue), object: object)
    }
}
