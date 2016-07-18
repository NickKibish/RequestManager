//
//  RequestManager.swift
//  RequestManager
//
//  Created by Nick Kibish on 7/17/16.
//  Copyright © 2016 TeamForProduct. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Log

public class RequestManager {
    public static let sharedInstance = RequestManager()
    public var shouldPrintSuccedResponse = false
    public var shouldPrintFailuredResponse = true
    public var baseURL: String = ""
}

//MARK: - Util Methods 
extension RequestManager {
    public var headers: [String: String]? {
        return nil
    }
    
    public func fullURL(url: String) -> String {
        return baseURL + url 
    }
}

//MARK: - Request Methods
extension RequestManager {
    public func request(method: Alamofire.Method,
                 url: URLStringConvertible,
                 parameters: [String: AnyObject]?,
                 success: ((JSON?) -> ())?,
                 failure: ((NSError?) -> ())?) {
        
        Alamofire.request(method, url, headers: headers, parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseData{ response in
                let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding)
                
                switch response.result {
                case .Success(let data):
                    let json = JSON(data: data)
                    if self.shouldPrintSuccedResponse {
                        Log.debug("Response OK: \(dataString)")
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        success?(json)
                    })
                    break
                case .Failure(let error):
                    if self.shouldPrintFailuredResponse {
                        Log.error("Response ERROR: \(dataString)")
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        failure?(error)
                    })
                    break
                }
        }
    }
}
