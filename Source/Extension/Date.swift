//
//  Date.swift
//  BasicKit
//
//  Created by Harvey on 2020/3/20.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public extension Date {
    
    enum Format: String {
        
        /// e.g. 2020-01-01
        case yyyyMMDD = "yyyy-MM-dd"

        /// e.g. 2020-01-01 01:01:01
        case yyyyMMDDHHmmss = "yyyy-MM-dd HH:mm:ss"
        
        /// e.g. 2020-01-01 01:01:01.088
        case yyyyMMDDHHmmssSSS = "yyyy-MM-dd HH:mm:ss.SSS"
        
        /// e.g. 2020年01月01日
        case yyyyMMDD1 = "yyy年MM月dd日"
        
        /// e.g. 2020年01月01日 01:01:01
        case yyyyMMDDHHmmss1 = "yyyy年MM月dd日 HH:mm:ss"
        
        /// e.g. 2020年01月01日 01:01:01.088
        case yyyyMMDDHHmmssSSS1 = "yyyy年MM月dd日 HH:mm:ss.SSS"
    }
}

public extension BasicKit where Base == Date {
    
    private static let formatter = DateFormatter()
    
    func local(_ format: Date.Format = .yyyyMMDDHHmmss) -> String {
        
        Self.formatter.dateFormat = format.rawValue
        return Self.formatter.string(from: base)
    }
}
