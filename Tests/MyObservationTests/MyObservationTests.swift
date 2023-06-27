import XCTest
@testable import MyObservation

final class Person {
    init() {
    }

    var name: String {
        get {
            _registrar.access(self, \.name)
            return _name
        }
        set {
            _registrar.willSet(self, \.name)
            _name = newValue
        }
    }

    var age: Int {
        get {
            _registrar.access(self, \.age)
            return _age
        }
        set {
            _registrar.willSet(self, \.age)
            _age = newValue
        }
    }
    var _name = "Tom"
    var _age = 25

    var _registrar = Registrar()
}

let sample = Person()
let sample1 = Person()

final class MyObservationTests: XCTestCase {
    func testObservation() throws {
        var numberOfCalls = 0
        withObservationTracking {
            _ = sample.name
        } onChange: {
            numberOfCalls += 1
        }
        XCTAssertEqual(numberOfCalls, 0)
        sample.age += 1
        XCTAssertEqual(numberOfCalls, 0)
        sample.name.append("!")
        XCTAssertEqual(numberOfCalls, 1)
        sample.name.append("!")
        XCTAssertEqual(numberOfCalls, 1)
    }

    func testObservationMultipleObjects() throws {
        var numberOfCalls = 0
        withObservationTracking {
            _ = sample.name
            _ = sample1.name
        } onChange: {
            numberOfCalls += 1
        }
        sample.name.append("!")
        XCTAssertEqual(numberOfCalls, 1)
        sample1.name.append("!")
        XCTAssertEqual(numberOfCalls, 1)
    }
}
