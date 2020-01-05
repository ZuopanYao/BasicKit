//
//  Number.swift
//  BasicKit
//
//  Created by Harvey on 2019/3/2.
//  Copyright © 2019 https://www.yaozuopan.top. All rights reserved.
//

import Foundation

public protocol NumberProtocol {
}

extension Int: NumberProtocol { }
extension Float: NumberProtocol { }
extension Double: NumberProtocol { }

public extension BasicKit where Base == Int {
    
    /// 随机生成无符号 Int
    ///
    /// 包含start、不包含end, end > start
    static func random(_ lower: Int = 0, _ upper: Int = Int.max) -> Int {
        
        return Int.random(in: lower..<upper)
    }
}

public extension BasicKit where Base == Float {
    
    /// 随机生成无符号 Float
    ///
    /// 包含start、不包含end, end > start
    static func random(_ lower: Float = Float.leastNormalMagnitude, _ upper: Float = Float.greatestFiniteMagnitude) -> Float {
        
        return Float.random(in: lower..<upper)
    }
    
    /// 保留多少位小数, 默认为1位
    func truncate(_ places: Int = 1) -> Float {
        return Float(Double(base).bk.truncate(places))
    }
}

public extension BasicKit where Base == Double {
    
    /// 随机生成无符号 Double
    ///
    /// 包含start、不包含end, end > start
    static func random(_ lower: Double = Double.leastNormalMagnitude, _ upper: Double = Double.greatestFiniteMagnitude) -> Double {
        
        return Double.random(in: lower..<upper)
    }
    
    /// 保留多少位小数
    func truncate(_ places: Int) -> Double {
     
        let factor = pow(10.0, Double(places))
        let intValue = Int(factor * base)
        return Double(intValue) / factor
    }
}
