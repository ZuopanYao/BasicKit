//
//  Async.swift
//  BasicKit
//
//  Created by Harvey on 2020/3/14.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public func async(delay: TimeInterval = 0.0, on: DispatchQueue = .main, block: @escaping (() -> Void)) {
    on.asyncAfter(deadline: DispatchTime.now() + delay, execute: block)
}
