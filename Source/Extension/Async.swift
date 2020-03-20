//
//  Async.swift
//  BasicKit
//
//  Created by Harvey on 2020/3/14.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation


/// 异步执行
/// - Parameters:
///   - delay: 延迟执行，单位秒，默认 0.0
///   - on: 在哪个线程上执行，默认为主线程
///   - block: 做些事情
public func async(delay: TimeInterval = 0.0, on: DispatchQueue = .main, block: @escaping (() -> Void)) {
    on.asyncAfter(deadline: DispatchTime.now() + delay, execute: block)
}
