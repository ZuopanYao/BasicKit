//
//  View.swift
//  BasicKit
//
//  Created by Harvey on 2020/1/6.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

#if os(macOS)
import AppKit

public extension NSView {
    
    /// Background Color
    var bgColor: NSColor? {
        set {
            if wantsLayer == false { wantsLayer = true }
            layer?.backgroundColor = newValue?.cgColor
        }
        
        get { if layer?.backgroundColor == nil { return nil }
            return NSColor(cgColor: layer!.backgroundColor!) }
    }
}

public extension NSButton {
    
    typealias Action = (AnyObject?, Selector?)

    /// 单击事件
    var click: Action {
        get { return (target, action) }
        set {
            target = newValue.0
            action = newValue.1
        }
    }
}

#else
import UIKit

public typealias BKAction = (AnyObject?, Selector, UIControl.Event)

public extension UIView {
    
    /// Background Color
    var bgColor: UIColor? {
        
        set { backgroundColor = newValue }
        get { return backgroundColor }
    }
    
    /// 单击事件
    var click: (AnyObject?, Selector)? {
        set {
            guard let  _ = newValue else { return }
            
            if isKind(of: UIControl.self) {
                (self as! UIControl).action = (newValue!.0, newValue!.1, .touchUpInside)
                return
            }
            
            isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: newValue!.0, action: newValue!.1)
            addGestureRecognizer(tap)
        }
        get { return nil }
    }
}

public extension UIControl {
    
    typealias Action = (AnyObject?, Selector, UIControl.Event)
    
    var action: Action? {
        set {
            guard let  _ = newValue else { return }
            addTarget(newValue!.0, action: newValue!.1, for: newValue!.2)
        }
        
        get { return nil }
    }
}

#endif
