//
//  Log.swift
//  
//
//  Created by Nick Kibish on 7/18/16.
//
//

import Log

class Log: Logger {
    static let sharedInstance = Log()
    
    class func trace(items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.trace(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    class func debug(items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.debug(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    class func info(items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.info(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    class func warning(items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.warning(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    class func error(items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.error(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    class func measure(description: String? = nil, iterations n: Int = 10, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function, block: () -> Void) {
        sharedInstance.measure(description, iterations: n, block: block)
    }
}
