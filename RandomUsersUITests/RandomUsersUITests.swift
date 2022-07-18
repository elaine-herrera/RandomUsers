//
//  RandomUsersUITests.swift
//  RandomUsersUITests
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import XCTest
import RandomUsers

class RandomUsersUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNavigation() throws {
        let cell = app.tables.cells.firstMatch
        let name = cell.staticTexts.element(matching: .any, identifier: "Name").label
        cell.tap()
        XCTAssert(app.staticTexts[name].exists)
        app.navigationBars.buttons.firstMatch.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
