//
//  InstaOperation.swift
//  InstaNetworking
//
//  Created by Islam on 2/6/20.
//  Copyright © 2020 App Lineup. All rights reserved.
//

import Foundation

class InstaOperation: Operation {

    private let lockQueue = DispatchQueue(label: "com.applineup.instanetwerok", attributes: .concurrent)
    private let executingKey = "isExecuting"
    private let finishKey = "isFinished"

    override var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: executingKey)
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: executingKey)
        }
    }

    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: finishKey)
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: finishKey)
        }
    }

    override func start() {
        isFinished = false
        isExecuting = true
        main()
    }

    override func main() {
        fatalError("Subclasses must implement `execute` without overriding super.")
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
}
