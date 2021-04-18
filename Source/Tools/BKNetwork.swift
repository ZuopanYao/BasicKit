//
//  BKNetwork.swift
//  BasicKit
//
//  Created by Harvey on 2019/6/8.
//  Copyright © 2019 姚作潘/Harvey. All rights reserved.
//

#if os(iOS)

import Foundation
import CoreTelephony
import Alamofire

public class BKNetwork {
    
    let telephonyNetworkInfo: CTTelephonyNetworkInfo
    var networkReachabilityManager: NetworkReachabilityManager!
    
    /// 监听网络变化
    public var reachabilityStatusDidChange: (()->(Void))? = nil

    init() {
        
        telephonyNetworkInfo = CTTelephonyNetworkInfo()
    
        guard let _networkReachabilityManager = NetworkReachabilityManager() else {
            
            BKLogv("NetworkReachabilityManager init failed")
            return
        }
        
        networkReachabilityManager = _networkReachabilityManager
        networkReachabilityManager.startListening { (networkReachabilityStatus) in

            BKLogv(networkReachabilityStatus)
            self.reachabilityStatusDidChange?()
        }
        
        
       // networkReachabilityManager.startListening(, onUpdatePerforming: NetworkReachabilityManager.Listener)
    }
    
    func reachabilityStatus(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) -> BKNetwork.`Type` {
        
        switch status {
            
        case .unknown:
            return ._Unknown
            
        case .notReachable:
            return ._NotReachable
            
        default:
            if networkReachabilityManager.isReachableOnEthernetOrWiFi {
                return ._WiFi
            }
            if networkReachabilityManager.isReachableOnCellular {
                return currentRadioAccessTechnology()
            }
        }
        
        return ._Unknown
    }
    
    public enum `Type`: String {
        
        case _Unknown = "Unknown"
        case _NotReachable = "NotReachable"
        case _WWAN = "WWAN"
        case _WiFi = "WiFi"
        case _2G = "2G"
        case _3G = "3G"
        case _4G = "4G"
    }
    
    public var type: BKNetwork.`Type` {
        
        return self.reachabilityStatus(networkReachabilityManager.status)
    }
    
    public struct Carrier {
        
        let base: BKNetwork
        let carrier: CTCarrier?
        
        init(_ base: BKNetwork) {
            
            self.base = base
            
            if #available(iOS 12.0, *) {
                carrier = self.base.telephonyNetworkInfo.serviceSubscriberCellularProviders?.values.first
            } else {
                carrier = self.base.telephonyNetworkInfo.subscriberCellularProvider
            }
        }
        
        public var name: String {
            
            return carrier?.carrierName ?? ""
        }
        
        public var mobileNetworkCode: String {
            
            return carrier?.mobileNetworkCode ?? ""
        }
        
        public var mobileCountryCode: String {
            
            return carrier?.mobileCountryCode ?? ""
        }
        
        public var isoCountryCode: String {
            
            return carrier?.isoCountryCode ?? ""
        }
        
        public var allowsVOIP: Bool {
            
            return carrier?.allowsVOIP ?? false
        }
    }
    
    public lazy var carrier: BKNetwork.Carrier = {
        
        return BKNetwork.Carrier(self)
    }()
    
    func currentRadioAccessTechnology() -> BKNetwork.`Type` {
        
        var optionalRadioAccessTechnology: String?
        if #available(iOS 12.0, *) {
            optionalRadioAccessTechnology = telephonyNetworkInfo.serviceCurrentRadioAccessTechnology?.values.first
        }else {
            optionalRadioAccessTechnology = telephonyNetworkInfo.currentRadioAccessTechnology
        }
        
        if let radioAccessTechnology = optionalRadioAccessTechnology {
            
            if radioAccessTechnology == CTRadioAccessTechnologyGPRS ||
                radioAccessTechnology == CTRadioAccessTechnologyEdge ||
                radioAccessTechnology == CTRadioAccessTechnologyCDMA1x {
                
                return ._2G
            }
            
            if radioAccessTechnology == CTRadioAccessTechnologyWCDMA ||
                radioAccessTechnology == CTRadioAccessTechnologyHSDPA ||
                radioAccessTechnology == CTRadioAccessTechnologyHSUPA ||
                radioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORev0 ||
                radioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORevA ||
                radioAccessTechnology == CTRadioAccessTechnologyCDMAEVDORevB ||
                radioAccessTechnology == CTRadioAccessTechnologyeHRPD {
                
                return ._3G
            }
            
            if radioAccessTechnology == CTRadioAccessTechnologyLTE {
                
                return ._4G
            }
        }
        
        return ._WWAN
    }
}

#endif
