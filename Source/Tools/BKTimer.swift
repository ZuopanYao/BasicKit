//
//  BKTimer.swift
//  BasicKit
//
//  Created by Harvey on 2020/3/20.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public class BKTimer {
    
    static let shared = BKTimer()
    private var timer: DispatchSourceTimer?
    
    private init() { }
    
    
    /// 计时器
    /// - Parameters:
    ///   - on: 执行线程
    ///   - duration: 持续时间，默认 Int.max
    ///   - interval: 每隔多少秒执行一次，默认 1.0
    ///   - handler: 处理Block
    
    public func schedule(on: DispatchQueue? = nil, duration: Float = Float(Int.max), interval: Float = 1.0, handler: @escaping ((_ newDuration: Float) -> Void)) -> Self {
        
        timer?.cancel()
        timer = nil
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: on)
        timer?.schedule(wallDeadline: DispatchWallTime.now() + TimeInterval(interval), repeating: Double(interval), leeway: DispatchTimeInterval.seconds(0))
        
        var newDuration = duration
        timer?.setEventHandler(handler: {
            
            newDuration -= interval
            handler(newDuration)
            
            if newDuration < interval {
                
                self.cancel()
            }
        })
        
        return self
    }
    
    public func resume() {
        timer?.resume()
    }
    
    public func suspend() {
        timer?.suspend()
    }
    
    public func cancel() {
        timer?.cancel()
    }
}
