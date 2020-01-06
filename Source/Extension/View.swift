//
//  View.swift
//  BasicKit
//
//  Created by Harvey on 2020/1/6.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

#if os(macOS)
import Cocoa

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

#else
import UIKit

public extension UIView {
    
    /// Background Color
    var bgColor: UIColor? {
        
        set { backgroundColor = newValue }
        get { return backgroundColor }
    }
}

#endif
