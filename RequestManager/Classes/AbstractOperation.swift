//
//  AbstractOperation.swift
//  Pods
//
//  Created by Nick Kibish on 7/18/16.
//
//

import Foundation

open class AbstractOperation: Operation {
    public enum State: String {
        case Ready, Executing, Finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue
        }
    }
    
    open var state = State.Ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override open var isReady: Bool {
        return super.isReady && state == .Ready
    }
    
    override open var isExecuting: Bool {
        return state == .Executing
    }
    
    override open var isFinished: Bool {
        return state == .Finished
    }
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    open override func start() {
        if isCancelled {
            state = .Finished
            return
        }
        
        main()
        state = .Executing
    }
    
    open override func cancel() {
        state = .Finished
    }
}

