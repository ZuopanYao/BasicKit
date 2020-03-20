//
//  Queue.swift
//  BasicKit
//
//  Created by Harvey on 2020/3/20.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public class Queue {
    
    /// 串行队列，异步执行
    /// - Parameters:
    ///   - tasks: 任务列表
    ///   - doneNotify: 完成通知
    public static func serial(tasks: [(() -> Void)], doneNotify: (on: DispatchQueue, block: (() -> Void))? = nil) {
        
        let taskQueue = DispatchQueue(label: "BK.Create.Serial.Queue.\(Int.random(in: 1..<9999))")
        taskQueue.async {
            
            let group = DispatchGroup()
            tasks.forEach { (task) in
                
                group.enter()
                task()
                group.leave()
            }
            
            if let _ = doneNotify {
                group.notify(queue: doneNotify!.on, execute: doneNotify!.block)
            }
        }
    }
    
    /// 并发队列
    /// - Parameters:
    ///   - tasks: 任务列表
    ///   - doneNotify: 完成通知
    public static func concurrent(tasks: [(() -> Void)], doneNotify: (on: DispatchQueue, block: (() -> Void))? = nil) {
        
        let taskQueue = DispatchQueue(label: "BK.Create.Concurrent.Queue.\(Int.random(in: 1..<9999))", attributes: .concurrent)
        
        let group = DispatchGroup()
        tasks.forEach { (task) in
            taskQueue.async(group: group, execute: DispatchWorkItem(block: task))
        }
        
        if let _ = doneNotify {
            group.notify(queue: doneNotify!.on, execute: doneNotify!.block)
        }
    }
}
