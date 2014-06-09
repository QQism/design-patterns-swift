// Playground - noun: a place where people can play

import Cocoa

"Hello"
"This is Object Pool playground"

class Office {
    var name: String = ""
    init(number: Int) {
        self.name = "Office " + String(number)
    }
}

class ObjectPool {
    var poolSize: Int = 0
    var createObjectBlock: (number: Int)->AnyObject
    var readyObjects = AnyObject[]()
    var allObjects = AnyObject[]()
    
    init(poolSize size: Int, createObjectBlock block: (no: Int)->AnyObject){
        self.poolSize = size
        self.createObjectBlock = block
    }
    
    func acquire() -> AnyObject? {
        var object:AnyObject? = nil
        
        if self.readyObjects.count > 0 {
            object = readyObjects.removeLast()
        }
        
        if (object == nil) {
            if self.allObjects.count < self.poolSize {
                var no = self.allObjects.count + 1
                object  = self.createObjectBlock(number: no)
                self.allObjects.append(object!)
            }
        }

        return object
    }
    
    func release(object: AnyObject) {
        if !self.readyObjects.bridgeToObjectiveC().containsObject(object) {
            self.readyObjects.append(object)
        }
    }
}

"Start with A Shared Building"
var sharedBuilding = ObjectPool(poolSize: 5, createObjectBlock: { (no) -> Office in return Office(number: no) })

"Acquire Office 1->" + String(sharedBuilding.poolSize)
var office1 = sharedBuilding.acquire() as Office
var office2 = sharedBuilding.acquire() as Office
var office3 = sharedBuilding.acquire() as Office
var office4 = sharedBuilding.acquire() as Office
var office5 = sharedBuilding.acquire() as Office

"There is no office any more"
var office6 = sharedBuilding.acquire() as? Office

"Release \(office1.name)"
sharedBuilding.release(office1)

var office7 = sharedBuilding.acquire()

"Release \(office2.name) and \(office3.name)"
sharedBuilding.release(office2)
sharedBuilding.release(office3)

var office8 = sharedBuilding.acquire()

"Farewell!"
