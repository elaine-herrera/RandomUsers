//
//  RandomUsersTests.swift
//  RandomUsersTests
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import XCTest
@testable import RandomUsers

class RandomUsersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfFullDecks() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let casino = Casino(path: "dataSet")
        let expected = 0
        XCTAssertEqual(casino.numberOfFullDecks(), expected, "The number of decks in example is \(expected)")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
