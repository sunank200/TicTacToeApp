//
//  TicTacToeUITests.swift
//  TicTacToeUITests
//
//  Created by Ankit Chaurasia on 17/04/25.
//

import XCTest

final class TicTacToeUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testAppTitleExists() throws {
        let app = XCUIApplication()
        app.launch()
        let title = app.staticTexts["Tic Tac Toe"]
        XCTAssertTrue(title.exists, "The app title should be present on launch.")
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
