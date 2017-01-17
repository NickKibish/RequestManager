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

extension JSON {
    init?(data: Data?) {
        if let data = data {
            self.init(data: data)
        }
        return nil
    }
}

public protocol Route {
    static var route: String { get }
}

public enum RequestManagerError: Error {
    case wrongURL
    case isntReachable
    case needsConnection
    
    case httpCode400(String?)
    case httpCode401(String?)
    case httpCode403(String?)
    case httpCode404(String?)
    case httpCode500(String?)
    
    case unknownError(String?)
}

open class URLString: URLConvertible {
    open var string: String
    
    public init(string: String) {
        self.string = string
    }
    
    public func asURL() throws -> URL {
        guard let url = URL(string: string) else {
            throw RequestManagerError.wrongURL
        }
        return url
    }
    
    open var URLString: String {
        guard let str = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return ""
        }
        return str
    }
}

open class RequestManager {
    public typealias SuccessResponse = ( (_ json: JSON?, _ response: HTTPURLResponse?) -> () )?
    public typealias SuccessArray<T> = ( ([T]) -> () )?
    public typealias SuccessDictionary = ( ([String:Any]) -> () )?
    public typealias Failure = ( (_ error: Error, _ json: JSON?) -> () )?
    
    open static let sharedInstance = RequestManager()
    open var baseURL: URLString = URLString(string: "")
    open var headers: HTTPHeaders? = nil
}

//MARK: - Util Methods 
extension RequestManager {
    public func fullURL(_ url: String) -> URLConvertible {
        let str = baseURL.string
        let urlString = URLString(string: str + url)
        return urlString
    }
}

//MARK: - Request Methods
extension RequestManager {
    public func request(route: Route.Type,
                        method: HTTPMethod,
                        parameters: [String: Any]?,
                        headers: HTTPHeaders? = nil) throws -> DataRequest {
        return try request(path: route.route, method: method, parameters: parameters, headers: headers)
    }
    
    public func request(path: String,
                        method: HTTPMethod,
                        parameters: [String: Any]?,
                        headers: HTTPHeaders? = nil) throws -> DataRequest {
        try Reachability.checkConnectedToNetwork()
        let url = try URLString(string: path)
        return Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default,
                                 headers: headers).validate(statusCode: 200..<300)
    }
    
    public func make(request: DataRequest, success: SuccessResponse, failure: Failure, procesQueue: DispatchQueue = DispatchQueue.main) {
        request.responseData { (response) in
            let json = JSON(data: response.data)
            
            procesQueue.async {
                switch response.result {
                case .success(let data):
                    success?(json, response.response)
                    break
                case .failure(let error):
                    guard let statusCode = response.response?.statusCode else {
                        failure?(RequestManagerError.unknownError(nil), json)
                        return
                    }
                    switch statusCode {
                    case 400: failure?(RequestManagerError.httpCode400(nil), json); break
                    case 401: failure?(RequestManagerError.httpCode401(nil), json); break
                    case 403: failure?(RequestManagerError.httpCode403(nil), json); break
                    case 404: failure?(RequestManagerError.httpCode404(nil), json); break
                    case 500: failure?(RequestManagerError.httpCode500(nil), json); break
                    default:
                        failure?(RequestManagerError.unknownError(nil), json)
                    }
                    
                    break
                }
            }
        }
    }
}
