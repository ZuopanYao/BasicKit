//
//  String.swift
//  BasicKit
//
//  Created by Harvey on 2019/6/5.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: - Base64
public extension BasicKit where Base == String {
    
    func dataValue(_ encoding: String.Encoding = .utf8) ->  Data {
        return  base.data(using: encoding) ?? Data()
    }
    
    func base64(_ encoding: String.Encoding = .utf8) -> Data.BK_SafeBase64 {
        
        return Data.BK_SafeBase64(dataValue(encoding))
    }
}

// MARK: - 类型转换
public extension BasicKit where Base == String {
    
    struct Value {
        
        let base: String
        fileprivate init(_ base: String) {
            self.base = base
        }
        
        public var float: Float { return Float(base) ?? 0.0 }
        public var double: Double { return Double(base) ?? 0.0 }
        public var int: Int { return Int(base) ?? 0 }
        public var bool: Bool { return Bool(base) ?? false }
    }
    
    var value: BasicKit<String>.Value { return Value(self.base) }
}

// MARK: - 一些常用功能
public extension BasicKit where Base == String {
    
    /// 判断字符串中是否含有中文字符
    ///
    /// Returns
    /// - false: 不含有中文字符
    /// - true: 含有中文字符
    ///
    var isIncludeChinese: Bool { return self.base.count+1 != self.base.utf8CString.count }
    
    /// 删除某些字符串或转义符号
    ///
    /// - Parameters:
    ///     - occurrences: 数组
    ///
    /// - Returns: String
    ///
    /// 使用示例
    ///
    ///     let string = "this is string"
    ///     string.trim(["\t", "is"])
    ///
    func trim(_ occurrences: [String] = ["\n"]) -> String {
        
        var origin: String = self.base
        occurrences.forEach { (element) in
            
            origin = origin.replacingOccurrences(of: element, with: "")
        }
        
        return origin
    }
    
    /// 生成随机字符串
    ///
    /// - Parameters:
    ///   - count: 生成字符串长度
    ///   - isLetter
    ///     - false: 大小写字母和数字组成
    ///     - true: 大小写字母组成
    ///     - 默认为false
    ///
    /// - Returns: String
    ///
    static func random(_ count: Int, _ isLetter: Bool = false) -> String {
        
        var ch: [CChar] = Array(repeating: 0, count: count)
        for index in 0..<count {
            
            var nums: [Int] = [Int.bk.random(97, 123),
                               Int.bk.random(65, 91),
                               Int.bk.random(48, 58)]
            
            if isLetter {
                _ = nums.popLast()
            }
            
            ch[index] = CChar(nums.randomElement()!)
        }
        
        return "\(String(cString: ch).prefix(count))"
    }
}

// MARK: - MD5
public extension String {
    
    struct BK_MD5 {
        
        let base: String
        init(_ base: String) {
            self.base = base
        }
        
        public var lower: String {
            
            let chars = base.cString(using: .utf8)!
            let bytesLength = CC_LONG(base.lengthOfBytes(using: .utf8))
            let digestLength = Int(CC_MD5_DIGEST_LENGTH)
            
            let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
            CC_MD5(chars, bytesLength, result)
            
            var hash: String = ""
            for i in 0..<digestLength {
                hash.append(String(format: "%02x", result[i]))
            }
            
            result.deallocate()
            return hash
        }
        
        public var upper: String { return lower.uppercased() }
    }
}

/// md5
public extension BasicKit where Base == String {
    
    var md5: String.BK_MD5 { return String.BK_MD5(base) }
}

public extension String {
    
    struct BK_transform {
        
        let base: String
        init(_ base: String) {
            self.base = base
        }
        
        /// 转成拼音
        ///
        /// - Parameter isLatin: true=不带声调, false=带声调, 默认 false
        public func pinyin(_ isLatin: Bool = false) -> String {
            
            let mutableString = NSMutableString(string: self.base)
            CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
            
            if isLatin {
                CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
            }
            return mutableString as String
        }
        
        
        /// 提取首字母, "中国" --> ZG
        ///
        /// - Parameter isUpper: false = 小写首字母, true = 大写首字母，默认 true
        public func initia(_ isUpper: Bool = true) -> String {
            
            let _pinyin = pinyin(true).components(separatedBy: " ")
            let initials = _pinyin.compactMap { String(format: "%c", $0.cString(using:.utf8)![0]) }
            
            return isUpper ? initials.joined().uppercased() : initials.joined()
        }
    }
}

public extension BasicKit where Base == String {
    
    /// 转换处理
    var transform: String.BK_transform { String.BK_transform(self.base) }
}
 

public extension BasicKit where Base == String {
    
    var file: URL.BK_File { URL.BK_File(URL(fileURLWithPath: base)) }
}

public extension BasicKit where Base == String {

    func writer(_ encoding: String.Encoding = .utf8) -> Data.BK_Writer {
        Data.BK_Writer(base.bk.dataValue(encoding))
    }
}
