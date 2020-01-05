//
//  ViewController.swift
//  BaseKit-Example-iOS
//
//  Created by Harvey on 2020/1/3.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import UIKit
import BaseKit

class myModel: BKObject {
    
    var name: String = ""
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        name = aDecoder.decodeObject(forKey: "name") as! String
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(name, forKey: "name")
    }
}

extension BK.Key {
    static let title = BK.Key("mytitle")
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let string = "hello"
//        print(string.bk.md5.lower)
//        print(string.bk.md5.upper)
//
//        let data = string.bk.dataValue()
//        print(data.bk.md5().lower)
//        print(data.bk.md5().upper)

        let string = """
外媒TPU表示，安培显卡采用了台积电的7nm制程节点，由于架构改变和制程更新带来的50%的性能提升不是不可能的，功耗的大幅下降也是在情理之中。据悉，英伟达现在的图灵显卡基于台积电的12纳米FinFET制造工艺，而其竞争对手AMD 的Navi显卡已经提前一步采用了7纳米工艺。
"""


        print(string.bk.transform.initia())
        print(string.bk.transform.pinyin())
        
        print(string.bk.transform.initia(false))
        print(string.bk.transform.pinyin(true))
        
//        let model = myModel()
//        model.name = "hahha"
//        model.bk.save()
    }
}

//5884215E-35CF-4E02-B468-7308D39BC629
//00000000-0000-0000-0000-000000000000
