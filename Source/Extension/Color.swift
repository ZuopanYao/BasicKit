//
//  Color.swift
//  BasicKit
//
//  Created by Harvey on 2020/1/6.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension Color {
    
    convenience init(red: UInt, green: UInt, blue: UInt, alpha: Float = 1.0) {
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
}

public extension BasicKit where Base == Color {
    
    /// 灰色 level in [0, 255]
    static func gray(_ level: UInt, alpha: Float = 1.0) -> Base {
        return Base(red: level, green: level, blue: level, alpha: alpha)
    }
    
    /// 十六进制颜色 e.g. 0xFFFF99
    static func hex(_ value: UInt) -> Base {
        
        let red = (value & 0xFF0000) >> 16
        let green = (value & 0x00FF00) >> 8
        let blue = value & 0x0000FF
        
        return Base(red: red, green: green, blue: blue)
    }
}
