//
//  Data.swift
//  BaseKit
//
//  Created by Harvey on 2019/6/5.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation

// MARK: - Base64
public extension Data {
    
    struct BK_SafeBase64 {
        
        let base: Data
        init(_ base: Data) {
            self.base = base
        }
        
        /// 解码
        public var decode: Data? {
            return Data(base64Encoded: self.base)
        }
        
        /// 解码成字符串
        public func decodedString(_ encoding: String.Encoding = .utf8) -> String {
            return decode?.bk.stringValue(encoding) ?? ""
        }
        
        /// 编码
        public var encode: Data? {
            return self.base.base64EncodedData()
        }
        
        /// 编码成字符串
        public func encodedString(_ encoding: String.Encoding = .utf8) -> String {
            return encode?.bk.stringValue(encoding) ?? ""
        }
    }
}

public extension BaseKit where Base == Data {
    
    func stringValue(_ encoding: String.Encoding = .utf8) ->  String {
        return String(data: self.base, encoding: encoding) ?? ""
    }
    
    /// base64
    var base64: Data.BK_SafeBase64 { return  Data.BK_SafeBase64(self.base) }
}

/// md5
public extension BaseKit where Base == Data {
   
    func md5(_ encoding: String.Encoding = .utf8) -> String.BK_MD5 {
        return String.BK_MD5(base.bk.stringValue(encoding))
    }
}

// MARK: - 写入文件
public extension Data {
    
    struct BK_Writer {
        
        let base: Data
        init(_ base: Data) {
            self.base = base
        }
        
        public func save(_ path: String) {
            
            do { try base.write(to: URL(fileURLWithPath: path), options: .atomic) }
            catch { BKLogv(error) }
        }
    }
}

public extension BaseKit where Base == Data {
    
    var writer: Data.BK_Writer { Data.BK_Writer(base) }
}
