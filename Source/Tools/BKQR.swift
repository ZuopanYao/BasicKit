//
//  BKQR.swift
//  BasicKit
//
//  Created by Harvey on 2020/1/6.
//  Copyright © 2020 姚作潘/Harvey. All rights reserved.
//

import CoreImage

#if os(macOS)
import Cocoa
public typealias Image = NSImage

extension Image {
    
    convenience init(ciImage: CIImage, size: NSSize) {
        self.init(size: size)
        
        lockFocus()
        ciImage.draw(at: .zero, from: CGRect(origin: .zero, size: size), operation: .copy, fraction: 1.0)
        unlockFocus()
    }
}

extension CGSize {
    
    init(w: Float, h: Float, scale: Float) {
        
        self.init()
        self.width = CGFloat(w * scale)
        self.height = CGFloat(h * scale)
    }
}

#else
import UIKit
public typealias Image = UIImage
#endif

extension Color {
    
    var coreImageColor: CIColor {
        #if os(macOS)
        return CIColor(color: self)!
        #else
        return CIColor(color: self)
        #endif
    }
}

public class BKQR {
    
    public struct Model {
        
        /// 文本
        public var text: String
        
        /// 二维码中间的logo
        public var logo: String?
        
        /// 二维码缩放倍数{27*scale,27*scale}
        public var scale: Float
        
        /// 二维码背景颜色
        public var backgroundColor: Color = Color.white
        
        /// 二维码颜色
        public var contentColor: Color = Color.black
        
        public init(text: String, scale: Float = 10.0, logo: String? = nil) {
            
            self.text = text
            self.scale = scale
            self.logo = logo
        }
    }
    
    static let shared = BKQR()
    
    private let qrFilter: CIFilter
    private let colorFilter: CIFilter
    
    private init() {
        
        /// 创建二维码滤镜
        qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        
        /// 创建颜色滤镜
        colorFilter = CIFilter(name: "CIFalseColor")!
    }
    
    private func createBase(text: String, scale: Float, _ encoding: String.Encoding = .utf8) -> CIImage? {
        
        qrFilter.setDefaults()
        guard let data = text.data(using: encoding) else {
            
            return nil
        }
        
        /// 给二维码滤镜设置inputMessage
        qrFilter.setValue(data, forKey: "inputMessage")
        guard var outputImage = qrFilter.outputImage else {
            
            return nil
        }
        
        outputImage = outputImage.transformed(by: CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale)))
        return outputImage
    }
    
    private func colourFilter(ciImage: CIImage, model: BKQR.Model) -> CIImage? {
        
        /// 颜色滤镜恢复默认值
        colorFilter.setDefaults()
        
        /// 设置颜色滤镜的inputImage
        colorFilter.setValue(ciImage, forKey: "inputImage")
        
        /// 设置inputImage的backgroundColor(key: inputColor1)
        colorFilter.setValue(model.backgroundColor.coreImageColor, forKey: "inputColor1")
        
        /// 设置inputImage的contentColor(key: inputColor0)
        colorFilter.setValue(model.contentColor.coreImageColor, forKey: "inputColor0")
        
        return colorFilter.outputImage
    }
    
    private func addLogo(ciImage: CIImage, model: BKQR.Model) -> Image? {
        
        guard let _ = model.logo, let logoImage = Image(named: model.logo!) else {
            return nil
        }
        
        #if os(macOS)
        let image = Image(ciImage: ciImage, size: NSSize(w: 27.0, h: 27.0, scale: model.scale))
        #else
        let image = Image(ciImage: ciImage)
        #endif
        
        let errorRateWidth = logoImage.size.width / image.size.width * 100.0
        let errorRateHeight = logoImage.size.height / image.size.height * 100.0
        
        /// 容错率判断
        if errorRateWidth > 30.0 || errorRateHeight > 30.0 {
            
            BKLogv("logo太大，已超过二维码最大容错率", "根据当前设置，logo最大为: \(image.size.width * 0.3)pt x \(image.size.width * 0.3)pt")
            return nil
        }
        
        BKLogv("二维码容错率: \(errorRateWidth > errorRateHeight ? errorRateWidth : errorRateHeight)%")
        let originX = (image.size.width - logoImage.size.width)/2.0
        let originY = (image.size.height - logoImage.size.height)/2.0
        
        #if os(macOS)
        
        image.lockFocus()
        logoImage.draw(in: CGRect(x: originX, y: originY, width: logoImage.size.width, height: logoImage.size.height))
        image.unlockFocus()
        
        return image
        #else
        
        UIGraphicsBeginImageContextWithOptions(image.size, true, BK.screen.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        logoImage.draw(in: CGRect(x: originX, y: originY, width: logoImage.size.width, height: logoImage.size.height))
        
        let outPutImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outPutImage
        
        #endif
    }
    
    public func create(_ model: BKQR.Model) -> Image? {
        
        guard var outputImage = createBase(text: model.text, scale: model.scale) else {
            return nil
        }
        
        if let colorOutputImage = colourFilter(ciImage: outputImage, model: model) {
            outputImage = colorOutputImage
        }
        
        guard let qrImageWithLogo = addLogo(ciImage: outputImage, model: model) else {
            
            #if os(macOS)
            return Image(ciImage: outputImage, size: CGSize(w: 27.0, h: 27.0, scale: model.scale))
            #else
            return Image(ciImage: outputImage)
            #endif
        }
        
        return qrImageWithLogo
    }
}
