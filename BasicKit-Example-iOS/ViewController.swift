//
//  ViewController.swift
//  BasicKit-Example-iOS
//
//  Created by Harvey on 2020/1/3.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import UIKit
import BasicKit
import ElegantSnap

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let iv = UIImageView()
        view.addSubview(iv, constraints: [.width(270), .height(270), .center()])
        
        var qrModel = BKQR.Model(text: "https://www.yaozuopan.top", scale: 10, logo: "128")
        //qrModel.backgroundColor = UIColor.bk.gray(188)
        qrModel.contentColor = .blue
        
        
        let qr = BK.qr.create(qrModel)
        
        BKLog(qr!.scale, qr!.size)
        iv.image = qr
        
        BKLog(iv.image!.scale, iv.image!.size)
    }
}
