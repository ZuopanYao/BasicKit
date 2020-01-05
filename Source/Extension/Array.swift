//
//  Array.swift
//  BasicKit
//
//  Created by Harvey on 2019/6/6.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation

public extension BasicKit where Base == [Int] {

    func sum() -> Base.Element {
        return self.base.reduce(0){ $0 + $1 }
    }
}

public extension BasicKit where Base == [Float] {

    func sum() -> Base.Element {
        return self.base.reduce(0.0){ $0 + $1 }
    }
}

public extension BasicKit where Base == [Double] {

    func sum() -> Base.Element {
        return self.base.reduce(0.0){ $0 + $1 }
    }
}

public extension BasicKit where Base == [String] {

    func writer(_ separator: String = "", encoding: String.Encoding = .utf8) -> Data.BK_Writer {
        
        return Data.BK_Writer(base.joined(separator: separator).bk.dataValue(encoding))
    }
}
