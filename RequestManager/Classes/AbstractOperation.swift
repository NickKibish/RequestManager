//
//  AbstractOperation.swift
//  Pods
//
//  Created by Nick Kibish on 7/18/16.
//
//

import Foundation

public class AbstractOperation: NSOperation {
    public enum State: String {
        case Ready, Executing, Finished
        
        private var keyPath: String {
            return "is" + rawValue
        }
    }
    
    public var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            willChangeValueForKey(state.keyPath)
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
    
    override public var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override public var executing: Bool {
        return state == .Executing
    }
    
    override public var finished: Bool {
        return state == .Finished
    }
    
    override public var asynchronous: Bool {
        return true
    }
    
    public override func start() {
        if cancelled {
            state = .Finished
            return
        }
        
        main()
        state = .Executing
    }
    
    public override func cancel() {
        state = .Finished
    }
}

