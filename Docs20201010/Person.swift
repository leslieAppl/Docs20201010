//
//  Person.swift
//  Docs20201010
//
//  Created by leslie on 10/13/20.
//

import Foundation

// Adopt secure coding for iOS 12
///NSObject: The root class of most Objective-C class hierarchies.
class Person: NSObject, NSSecureCoding {
    
    // Implement this property conforming to NSSecureCoding
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var firstName: String
    var lastName: String
    
    override var description: String {
        return self.firstName + " " + self.lastName
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        super.init()
    }

    // MARK: - NSCoding Stubs
    func encode(with coder: NSCoder) {
        coder.encode(self.lastName, forKey: "last")
        coder.encode(self.firstName, forKey: "first")
    }
    
    required init?(coder: NSCoder) {
        ///Decode custom class which adopted NSCoding protocol
        self.lastName = coder.decodeObject(of: NSString.self, forKey: "last")! as String
        self.firstName = coder.decodeObject(of: NSString.self, forKey: "first")! as String
        
        super.init()
    }
}

// but in Swift 4 we are more likely to do it this way
class Person2: NSObject, Codable {
    
}
