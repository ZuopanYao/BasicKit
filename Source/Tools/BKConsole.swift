//
//  BKConsole.swift
//  BaseKit
//
//  Created by Harvey on 2019/6/10.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation

/// 自定义打印函数
func BKLogv(_ items: Any..., file: String = #file, method: String = #function, line: Int = #line) {
    
    var string = "[BaseKit] \(BKConsole.shared.dateString) in \(file.split(separator: "/").last!) \(method) [Line \(line)]:\n"
    print(string, terminator: "")
    
    for item in items {
        
        print(item)
        string = string + "\(item)\n"
    }
    print("")
}

public class BKConsole {
    
    let formatter: DateFormatter
    static let shared = BKConsole()
    
    /// 日记保存路径
    public var path: String = {
        return NSHomeDirectory() + "/Documents/\(BK.app.bundleID).txt"
    }()
    
    /// 清空保存到文件的日记
    public func clear() {
        logs = []
        "".bk.writer().save(path)
    }
    
    /// 日记保存限制，超过自动清空，, 单位为MB， 默认为 1.0MB
    public var limitByte: Float = 1.0
    
    /// 获取日记
    public lazy var logs: [String] = {
        
        if path.bk.file.size.mb >= limitByte {
            return []
        }
        
        if let value = try? String(contentsOfFile: path) {
            return [value]
        }
        return []
    }()
    
    func save(_ log: String) {
        
        logs.append(log)
        logs.bk.writer("\n").save(path)
    }
    
    init() {
        
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    var dateString: String {
        
        return formatter.string(from: Date())
    }
}

/// BaseKit 自定义打印函数
public func BKLog(_ items: Any..., file: String = #file, method: String = #function, line: Int = #line) {
    
    var string = "\(BKConsole.shared.dateString) in \(file.split(separator: "/").last!) \(method) [Line \(line)]:\n"
    print(string, terminator: "")
    
    for item in items {
        
        print(item)
        string = string + "\(item)\n"
    }
    print("")
    
    // write to file if need
    BKConsole.shared.save("\(string)")
}
