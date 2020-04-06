import UIKit

// KVO - Key-Value Observing
//KVO is an observer pattern
// NotificationCenter is also an observer pattern
// KVO is a one-to-many pattern relationship as oppose dto delegation which is one-to-one

// In Delegation Pattern
// class ViewController: UIViewController {}
// eg. tableView.dataSource = self

//KVO is an Objective-C runtime API
// KVO only works with references so we must use a class
//Along with KVO being an objective-c runtime, some essentials are required
// 1. The object being observed needs to be a class
// 2. The class needs to inherit from NSObject, NSObject is the top abstract class in Objective-C
// 3. Any property being marked for observation needs to be prefixed with @objc dynamic. Dynamic means that the property is being dynamically dispatched (at runtime the compiler verifies the underlying property)
// In swift types are statically dispatched which means they are checked at compile time vs. Objective-C which is dynamically dispatched and checked at runtime

// The compiler is written in C++ and C

//Static vs. dynamic dispatch
// https://medium.com/flawless-app-stories/static-vs-dynamic-dispatch-in-swift-a-decisive-choice-cece1e872d


// Dog class (Class being observed) - will have a property to be observed
// the class inherits form NSObject and is also marked as objective c
// if you want a property to be observable you have to mark it as objective c and make it a dynamic variable
@objc class Dog: NSObject {
    var name: String
   @objc dynamic var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

//Observer class one
class DogWalker {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? // this is a handle for th eproperty being observed i.e age property on Dog class
    
    init(dog: Dog) {
        self.dog = dog
        
        // if this isn't called nothing is observered
        configureBirthdayObservation()
    }
    
    // we use this to remove it
    private func configureBirthdayObservation() {
        // \.age is keyPath syntax for KVO observing
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler:{ (dog, change) in
            // using "change" in the completion handler we can now use the updated information to update any related objects/properties
            // update UI accordingly if in a ViewController class
            
            guard let age = change.newValue else { return }
            print("Hey \(dog.name), happy \(age) birthday from the dog walker")
            
            print("oldValue is \(change.oldValue ?? 0)")
            print("newValue is \(change.newValue ?? 0)")
            })
        
       
    }
    
}


//Observer class two
class DogGroomer {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation?
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new
            ], changeHandler: { (dog, change) in
           
            
            guard let age = change.newValue else { return }
            print("Hey \(dog.name), happy \(age) birthday from the dog groomer.")
            print("groomer oldvalue: \(change.oldValue ?? 0)")
            print("groomer newValue: \(change.newValue ?? 0)")
            
        })
    }
    
}

// test out KVO observing on the .age property of the Dog
// both classes (DogWalker and DogGrommer should get .age changes)

let snoopy = Dog(name: "Snoopy", age: 5)
let dogWalker = DogWalker(dog: snoopy) // bothe dogWalker and gogGroomer
let dogGroomer = DogGroomer(dog: snoopy)

snoopy.age += 1
snoopy.age += 1
snoopy.age += 1
