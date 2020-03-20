//
//  URL.swift
//  BasicKit
//
//  Created by Harvey on 2020/1/5.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public extension URL {
    
    struct BK_File {
        
        let base: URL
        init(_ base: URL) {
            self.base = base
        }
        
        /// 后缀名
        ///
        /// - Parameter isUpper: false = 小写后缀名，true = 大写后缀名，默认为false
        public func suffix(_ isUpper: Bool = false) -> String {
            
            let _suffix = base.pathExtension
            return isUpper ? _suffix.uppercased() : _suffix.lowercased()
        }
        
        /// 带后缀的文件名
        public var name: String {
            return base.lastPathComponent
        }
        
        /// 不带后缀的文件名
        public var nameWithoutSuffix: String {
            
            var _nameWithSuffix = name.components(separatedBy: ".")
            _ = _nameWithSuffix.popLast()
            return _nameWithSuffix.joined(separator: ".")
        }
        
        public var folder: String {
            if base.pathExtension.count == 0 {
                return base.lastPathComponent
            }
            
            return base.pathComponents.suffix(2).first ?? ""
        }
        
        public struct Size {
            
            let base: URL
            /// apple
            let binary: Float = 1000
            
            public var byte: Int = 0
            private let fileManager = FileManager.default
            
            init(_ base: URL) {
                self.base = base
                if base.pathExtension.count == 0 { folderSize() }
                else { fileSize(base.path) }
            }
            
            private mutating func fileSize(_ filePath: String) {
                
                do{ let attributes = try fileManager.attributesOfItem(atPath: filePath)
                    self.byte += attributes[.size] as! Int
                }catch { BKLogv(error) }
            }
            
            private mutating func folderSize() {
                
                guard let files = fileManager.subpaths(atPath: base.path) else {
                    return
                }
                
                files.forEach { (filePath) in
                    self.fileSize(base.path + "/" + filePath)
                }
            }
            
            public var kb: Float {
                return Float(byte) / binary
            }
            
            public var mb: Float {
                return Float(kb) / binary
            }
            
            public var gb: Float {
                return Float(mb) / binary
            }
        }
        
        public var size: BK_File.Size { BK_File.Size(base) }
    }
}

public extension BasicKit where Base == URL {
    
    var file: URL.BK_File { URL.BK_File(base) }
}
