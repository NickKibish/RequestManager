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

public class URLString: NSObject, URLStringConvertible {
    public var string: String
    public init(string: String) {
        self.string = string
    }
    
    public var URLString: String {
        guard let str = string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            return ""
        }
        return str
    }
}

public class RequestManager {
    public typealias Success = ((JSON?) -> ())?
    public typealias Failure = ((NSError?) -> ())?
    
    public static let sharedInstance = RequestManager()
    public var shouldPrintSuccedResponse = false
    public var shouldPrintFailuredResponse = true
    public var baseURL: URLString = URLString(string: "")
}

//MARK: - Util Methods 
extension RequestManager {
    public var headers: [String: String]? {
        return nil
    }
    
    public func fullURL(url: String) -> URLStringConvertible {
        let str = baseURL.string
        let urlString = URLString(string: str + url)
        return urlString
    }
}

//MARK: - Request Methods
extension RequestManager {
    public func request(method: Alamofire.Method,
                 url: URLStringConvertible,
                 parameters: [String: AnyObject]?,
                 success: Success,
                 failure: Failure) {
        
        Alamofire.request(method, url, headers: headers, parameters: parameters, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseData{ response in
                let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding)
                
                switch response.result {
                case .Success(let data):
                    let json = JSON(data: data)
                    if self.shouldPrintSuccedResponse {
                        Log.debug("Request OK: \(response.request?.URL)")
                        Log.debug("Response OK: \(dataString)")
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        success?(json)
                    })
                    break
                case .Failure(let error):
                    if self.shouldPrintFailuredResponse {
                        Log.debug("Request ERROR: \(response.request?.URL)")
                        Log.error("Response ERROR: \(dataString)")
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        failure?(error)
                    })
                    break
                }
        }
    }
    
    public func request(method: Alamofire.Method,
                        baseURL: String,
                        parameters: [String: AnyObject]?,
                        success: Success,
                        failure: Failure) {
        request(method, url: fullURL(baseURL), parameters: parameters, success: success, failure: failure)
    }
}
