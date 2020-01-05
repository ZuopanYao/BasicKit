//
//  File.swift
//  BasicKit-Example-iOS
//
//  Created by Harvey on 2020/1/3.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    func bk_allKeys() -> [Key] {
        return self.keys.shuffled()
    }
    
    func bk_allValues() -> [Value] {
        return self.values.shuffled()
    }
}
