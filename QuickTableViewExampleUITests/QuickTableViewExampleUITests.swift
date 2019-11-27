//
//  QuickTableViewExampleUITests.swift
//  QuickTableViewExampleUITests
//
//  Created by Ron Srebro on 11/26/19.
//  Copyright © 2019 ronsrebro. All rights reserved.
//

import XCTest

class QuickTableViewExampleUITests: XCTestCase {

    let app = XCUIApplication()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() {
//        // UI tests must launch the application that they test.
//
//
//
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//
    func testBasicAddingRows() {
        
        
        app.buttons["Test Add"].tap()
        
        let table = app.tables.firstMatch
        var lastCount = table.staticTexts.count
        
        let addNewStaticText = table.staticTexts["Add New"]
        
        
        addNewStaticText.tap()
        XCTAssertEqual(table.staticTexts.count, lastCount + 1)
        XCTAssertNotNil(table.staticTexts["5"])
        lastCount += 1
        
        
        addNewStaticText.tap()
        XCTAssertEqual(table.staticTexts.count, lastCount + 1)
        XCTAssertNotNil(table.staticTexts["6"])
        lastCount += 1
        
        addNewStaticText.tap()
        XCTAssertEqual(table.staticTexts.count, lastCount + 1)
        XCTAssertNotNil(table.staticTexts["7"])
        lastCount += 1
        
        
        app.navigationBars["_TtGC14QuickTableView24QuickTableView"].buttons["Done"].tap()
                
    }
    
    
    
  
    func testDelete() {
        let app = XCUIApplication()
        app.buttons["Test Delete"].tap()

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["4"]/*[[".cells.staticTexts[\"4\"]",".staticTexts[\"4\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()

        let trailing0Button = tablesQuery/*@START_MENU_TOKEN@*/.buttons["trailing0"]/*[[".cells",".buttons[\"Delete\"]",".buttons[\"trailing0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        trailing0Button.tap()
        XCTAssertFalse(tablesQuery.staticTexts["4"].exists)

        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".cells.staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        trailing0Button.tap()
        XCTAssertFalse(tablesQuery.staticTexts["2"].exists)
        
        app.navigationBars["_TtGC14QuickTableView24QuickTableView"].buttons["Done"].tap()
        
        
    }
    
    func testFilter() {
        
        let app = XCUIApplication()
        app.buttons["Test Filter"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element.tap()
        app.typeText("4")
        
        XCTAssertEqual(tablesQuery.children(matching: .cell).count,1)
        
        //app.text
        
    }
}
