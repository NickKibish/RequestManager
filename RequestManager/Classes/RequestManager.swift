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



open class URLString: URLConvertible {
    open var string: String
    
    public init(string: String) {
        self.string = string
    }
    
    public func asURL() throws -> URL {
        return URL(string: <#T##String#>)
    }
    
    open var URLString: String {
        guard let str = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return ""
        }
        return str
    }
}

open class RequestManager {
    public typealias Success = ((JSON?) -> ())?
    public typealias Failure = ((JSON?, NSError?) -> ())?
    public typealias SuccessResponse = ((JSON?, _ response: URLR) -> ())?
    public typealias FailureResponse = ((JSON?, NSError?, _ response: Response<NSData, NSError>?) -> ())?
    
    open static let sharedInstance = RequestManager()
    open var shouldPrintSuccedResponse = false
    open var shouldPrintFailuredResponse = true
    open var baseURL: URLString = URLString(string: "")
    open var encoding: ParameterEncoding = .JSON
}

//MARK: - Util Methods 
extension RequestManager {
    public var headers: [String: String]? {
        return nil
    }
    
    public func fullURL(_ url: String) -> URLStringConvertible {
        let str = baseURL.string
        let urlString = URLString(string: str + url)
        return urlString
    }
}

//MARK: - Request Methods
extension RequestManager {
    public func request(_ method: Alamofire.Method,
                 url: String,
                 parameters: [String: AnyObject]?,
                 success: SuccessResponse,
                 failure: FailureResponse) {
        
        Alamofire.request(url, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
        
        Alamofire.request(method, url, headers: headers, parameters: parameters, encoding: encoding)
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
                        success?(json, response: response)
                    })
                    break
                case .Failure(let error):
                    if self.shouldPrintFailuredResponse {
                        Log.debug("Request ERROR: \(response.request?.URL)")
                        Log.error("Response ERROR: \(dataString)")
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        guard let data = response.data else {
                            failure?(nil, error, response: response)
                            return
                        }
                        
                        let json = JSON(data: data)
                        failure?(json, error, response: response)
                    })
                    break
                }
        }
    }
    
    public func request(_ method: Alamofire.Method,
                        baseURL: String,
                        parameters: [String: AnyObject]?,
                        success: SuccessResponse,
                        failure: FailureResponse) {
        request(method, url: fullURL(baseURL), parameters: parameters, success: success, failure: failure)
    }
    
    public func request(_ method: Alamofire.Method,
                        baseURL: String,
                        parameters: [String: AnyObject]?,
                        success: Success,
                        failure: Failure) {
        request(method, url: fullURL(baseURL), parameters: parameters, success: { (json, response) in
            success?(json)
            }) { (json, error, response) in
                failure?(json, error)
        }
    }
}
