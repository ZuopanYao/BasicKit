//
//  ViewController.swift
//  BasicKit-Example-macOS
//
//  Created by Harvey on 2020/1/4.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import Cocoa
import BasicKit

extension BKNotify.Name {
    static let myname = BKNotify.Name("ddkkdkd")
}

class Model: BKType, Codable {
    
    var name: String = ""
    var age: Int = 0
    var address: String = ""
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = Model()
        model.name = "yaozuo"
        model.age = 10
        model.address = "0000000"
        
        BKLog(model.bk.json())
        
        let json = "{\"name\":\"yaozuo\",\"age\":10,\"address\":\"0000000\"}"
        
        BKLog(Model.bk.fromJSON(data: json.bk.dataValue())?.address)
        BKLog(Model.bk.fromJSON(string: json)?.address)
        
//        model.bk.
//        BKLog(model.bk.json())
        
        //BK.security.config = (.des(mode: .ecb), "33253E97AADD6F2E", "33253E97AADD6F2E")

        //let file = "XHZ+3Y4JaX3Y1JKtMRMLFuZrOLunNcnOuDnynfVhKUgW8Zss/x3luA=="
        //BKLog(file.bk.decrypt(.gb18030))
//
//        let size = file.bk.file.size
//
//        BKLog(size.byte, size.kb, size.mb, size.gb)
//        BKLog(size.byte, size.kb.bk.truncate(3), size.mb.bk.truncate(3), size.gb.bk.truncate(3))

        //let file = URL(string: "/Users/harvey/Downloads/333.gg.nenew.mp4")!
        //BKLog([file.bk.file.name, file.bk.file.nameWithSuffix, file.bk.file.suffix(), file.bk.file.suffix(true)])
        
        //BKLog(file.bk.file.name, file.bk.file.nameWithoutSuffix, file.bk.file.suffix())
        // Do any additional setup after loading the view.
        
//        let key = "kkfkgggkg"
//
//        //let m = Model()
//        //BK.storager.setCodable(m, key: BK.Key(key))
//
//        let g = BK.storager.codable(key: BK.Key(key), Model.self)
//        BKLog(g?.name)
//
        //BKLog(m is Codable)
        //BKLog(UserDefaults.standard.value(forKey: key))
//
//        "".bk.writer().save("")
//        BKLog(BK.logger.path)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

