//
//  BKObject.swift
//  BasicKit
//
//  Created by Harvey on 2019/6/6.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

import Foundation

open class BKType {
    public init() { }
}

public extension BasicKit where Base: BKType, Base: Codable {
    
    static func fromJSON(data: Data? = nil, string: String? = nil, _ encoding: String.Encoding = .utf8) -> Base? {
        
        if let _ = data, let _ = string {
            return nil
        }
        
        var _data: Data!
        if let _ = data {
            _data = data!
        }
        
        if let _ = string {
            _data = string!.bk.dataValue(encoding)
        }
        
        do { return try JSONDecoder().decode(Base.self, from: _data) }
        catch { BKLogv(error) }
        return nil
    }
    
    func json(_ encoding: String.Encoding = .utf8) -> (data: Data, string: String)? {
        
        do {
            let data = try JSONEncoder().encode(self.base)
            return (data, data.bk.stringValue(encoding))
        } catch {
            BKLogv(error)
        }
        return nil
    }
}
