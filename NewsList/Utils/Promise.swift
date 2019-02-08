//
//  Promise.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 29/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

final class Promise<T> {
    
    private var action: (_ promise: Promise) -> () = { promise in }
    
    init(_ action: @escaping (_ promise: Promise) -> ()) {
        self.action = action
        restartExecution()
    }
    
    func restartExecution() {
        action(self)
    }
    
    var then: (_ response: T) -> () = { _ in }
    
    func then(_ action: @escaping (_ response: T) -> ()) -> Promise<T> {
        then = { response in
            self.anyway()
            action(response)
        }
        
        return self
    }
    
    var `catch`: (_ error: Error) -> () = { _ in }
    
    @discardableResult func `catch`(_ action: @escaping (_ error: Error) -> ()) -> Promise<T> {
        `catch` = { error in
            self.anyway()
            action(error)
        }
        
        return self
    }
    
    private var anyway: () -> () = { }
    
    func anyway(_ action: @escaping () -> ()) {
        anyway = action
    }
    
}

