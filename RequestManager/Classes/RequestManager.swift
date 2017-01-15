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
    case httpCode403(String?)
    case httpCode404(String?)
    
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
    public typealias Success = ((JSON?) -> ())?
    public typealias Failure = ((JSON?, NSError?) -> ())?
    public typealias SuccessResponse = ((JSON?, _ response: HTTPURLResponse?) -> ())?
    public typealias FailureResponse = ((JSON?, Error, _ response: HTTPURLResponse?) -> ())?
    
    public typealias SuccessArray<T> = ([T]) -> ()
    public typealias SuccessDictionary<T> = ([String:T]) -> ()
    public typealias Filure = (Error)
    
    open static let sharedInstance = RequestManager()
    open var baseURL: URLString = URLString(string: "")
}

//MARK: - Util Methods 
extension RequestManager {
    public var headers: [String: String]? {
        return nil
    }
    
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
                        parameters: [String: Any]?) throws -> DataRequest {
        return try request(path: route.route, method: method, parameters: parameters)
    }
    
    public func request(path: String,
                        method: HTTPMethod,
                        parameters: [String: Any]?) throws -> DataRequest {
        try Reachability.checkConnectedToNetwork()
        let url = try URLString(string: path)
        return Alamofire.request(url, method: method, parameters: parameters).validate(statusCode: 200..<300)
    }
    
    public func make(request: DataRequest, success: SuccessResponse, failure: FailureResponse, procesQueue: DispatchQueue = DispatchQueue.main) {
        request.responseData { (response) in
            let json = JSON(data: response.data)
            
            procesQueue.async {
                switch response.result {
                case .success(let data):
                    success?(json, response.response)
                    break
                case .failure(let error):
                    failure?(json, RequestManagerError.unknownError(nil), response.response)
                    break
                }
            }
        }
    }
}
