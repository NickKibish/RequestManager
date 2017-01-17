//
//  Log.swift
//  
//
//  Created by Nick Kibish on 7/18/16.
//
//

import Log

open class Log: Logger {
    open static let sharedInstance = Log(formatter: .detailed, theme: nil, minLevel: .trace)
    
    open class func trace(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.trace(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    open class func debug(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.debug(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    open class func info(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.info(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    open class func warning(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.warning(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    open class func error(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        sharedInstance.error(items, separator: separator, terminator: terminator, file: file, line: line, column: column, function: function)
    }
    
    open class func measure(_ description: String? = nil, iterations n: Int = 10, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function, block: () -> Void) {
        sharedInstance.measure(description, iterations: n, block: block)
    }
}
