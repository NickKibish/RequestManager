//
//  AbstractOperation.swift
//  Pods
//
//  Created by Nick Kibish on 7/18/16.
//
//

import Foundation

class AbstractOperation: NSOperation {
    enum State: String {
        case Ready, Executing, Finished
        
        private var keyPath: String {
            return "is" + rawValue
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            willChangeValueForKey(state.keyPath)
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
    
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    internal override func start() {
        if cancelled {
            state = .Finished
            return
        }
        
        main()
        state = .Executing
    }
    
    internal override func cancel() {
        state = .Finished
    }
}

