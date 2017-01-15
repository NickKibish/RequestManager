//
//  Reachability.swift
//  RequestManager
//
//  Created by Nick Kibish on 7/17/16.
//  Copyright © 2016 TeamForProduct. All rights reserved.
//

import SystemConfiguration

open class Reachability {
    class func checkConnectedToNetwork() throws {
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            throw RequestManagerError.isntReachable
        }
        if !((flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0) {
            throw RequestManagerError.isntReachable
        }
        if ((flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0) {
            throw RequestManagerError.needsConnection
        }
    }
}
