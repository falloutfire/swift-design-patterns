import Foundation

public final class WeakList<T>: Sequence {

    private let hashTable = NSHashTable<AnyObject>.weakObjects()
    
    public init() {}

    public func add(_ object: T) {
        hashTable.add(object as AnyObject)
    }

    public func remove(_ object: T) {
        hashTable.remove(object as AnyObject)
    }

    public var count: Int {
        return hashTable.allObjects.count
    }

    public var isEmpty: Bool {
        return count == 0
    }

    public func makeIterator() -> Array<T>.Iterator {
        let delegates = hashTable.allObjects.compactMap { $0 as? T }
        return delegates.makeIterator()
    }
}
