//
//  BKSecurity.swift
//  CertCheck
//
//  Created by Harvey on 2019/8/22.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation
import CommonCrypto

let cryptError: [Int: String] =
    [
        kCCSuccess: "kCCSuccess",
        kCCParamError: "kCCParamError",
        kCCBufferTooSmall: "kCCBufferTooSmall",
        kCCMemoryFailure: "kCCMemoryFailure",
        kCCAlignmentError: "kCCAlignmentError",
        kCCDecodeError: "kCCDecodeError",
        kCCUnimplemented: "kCCUnimplemented",
        kCCOverflow: "kCCOverflow",
        kCCRNGFailure: "kCCRNGFailure",
        kCCUnspecifiedError: "kCCUnspecifiedError",
        kCCCallSequenceError: "kCCCallSequenceError",
        kCCKeySizeError: "kCCKeySizeError",
        kCCInvalidKey: "kCCInvalidKey"
]

extension Data {
    
    func bytes() -> [UInt8] {
        
        var keyByte = [UInt8](repeating: 0, count: count)
        copyBytes(to: &keyByte, count: count)
        
        return keyByte
    }
}

public class BKSecurityCore {
    
    public enum Mode {
        
        case cbc
        case ecb
        
        func rawValue() -> Int {
            
            switch self {
                
            case .cbc: return kCCOptionPKCS7Padding
            case .ecb: return kCCOptionECBMode | kCCOptionPKCS7Padding
            }
        }
    }
    
    public enum Algorithm {
        
        case aes(mode: Mode)
        case des(mode: Mode)
        
        func rawValue() -> (value: Int, mode: Mode, blockSize: Int, keySize: Int) {
            
            switch self {
                
            case .aes(let mode): return (kCCAlgorithmAES, mode, kCCBlockSizeAES128, -1)
            case .des(let mode): return (kCCAlgorithmDES, mode, kCCBlockSizeDES, kCCKeySizeDES)
            }
        }
    }
    
    struct Factor {
        
        let key: String
        let iv: String
        let KeySize: Int
        
        ///
        /// - Parameters:
        ///   - key: Length of key should be 16, 24 or 32(128, 192 or 256bits).
        ///   - iv: Length of iv should be 16, 24 or 32(128, 192 or 256bits), only CBC mode.
        init(key: String, iv: String = "") {
            
            if key.count != 16, key.count != 24, key.count != 32 {
                
                fatalError("Length of key is wrong. Length of iv should be 16, 24 or 32(128, 192 or 256bits)")
            }
            
            if iv.count != 16, iv.count != 24, iv.count != 32 {
                
                fatalError("Length of iv should be 16, 24 or 32(128, 192 or 256bits), only CBC mode.")
            }
            
            self.key = key
            self.iv = iv
            self.KeySize = key.count
        }
    }
    
    /// 加密
    ///
    /// - Parameters:
    ///   - value: 将要加密的内容
    ///   - factor: 加密要素
    ///   - algorithm: 加密算法
    /// - Returns: base64 Encoded String
    static func encrypt(_ value: String, factor: Factor, algorithm: Algorithm = .aes(mode: .cbc), _ encoding: String.Encoding = .utf8) -> String? {
        
        if let encryptValue = crypt(value.bk.dataValue(encoding), operation: CCOperation(kCCEncrypt), factor: factor, algorithm: algorithm) {
            
            return encryptValue.base64EncodedString()
        }
        
        return nil
    }
    
    /// 解密
    ///
    /// - Parameters:
    ///   - value: 将要解密的内容(base64 Encoded String)
    ///   - factor: 加密要素
    ///   - algorithm: 加密算法
    /// - Returns: String
    static func decrypt(_ base64Value: String, factor: Factor, algorithm: Algorithm = .aes(mode: .cbc), _ encoding: String.Encoding = .utf8) -> String? {
        
        if  let data = Data(base64Encoded: base64Value),
            let decryptValue = crypt(data, operation: CCOperation(kCCDecrypt), factor: factor, algorithm: algorithm) {
            
            return decryptValue.bk.stringValue(encoding)
        }
        
        return nil
    }
    
    private static func crypt(_ value: Data, operation: CCOperation, factor: Factor, algorithm: Algorithm) -> Data? {
        if algorithm.rawValue().mode == .cbc {
            if factor.KeySize != factor.iv.count {
                fatalError("iv must be the same length as key")
            }
        }
        
        var KeySize = algorithm.rawValue().keySize
        if KeySize == -1 {
            KeySize = factor.KeySize
        }
        
        let bufferSize = value.count + algorithm.rawValue().blockSize;
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        var encryptedSize: Int = 0
        
        let status = CCCrypt(operation,
                             CCAlgorithm(algorithm.rawValue().value),
                             CCOptions(algorithm.rawValue().mode.rawValue()),
                             factor.key.bk.dataValue().bytes(),
                             KeySize,
                             factor.iv.bk.dataValue().bytes(),
                             value.bytes(),
                             value.bytes().count,
                             &buffer,
                             bufferSize,
                             &encryptedSize)
        
        BKLogv("Crypt Status:" + (cryptError[Int(status)] ?? "unknow:\(status)"))
        if status == kCCSuccess {
            
            return Data(bytes: buffer, count: encryptedSize)
        }
        
        return nil
    }
}

