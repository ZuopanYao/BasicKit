//
//  BKScreen.swift
//  BaseKit
//
//  Created by Harvey on 2019/6/7.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

#if os(iOS)

import UIKit

public class BKScreen {
    
    init() {  }
    public var width: CGFloat { return UIScreen.main.bounds.size.width }
    public var height: CGFloat { return UIScreen.main.bounds.size.height }
    public var scale: CGFloat { return UIScreen.main.scale }
}

#endif
