//
//  ios_football_appUITests.swift
//  ios-football-appUITests
//
//  Created by Kelvin Fok on 5/3/23.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift

final class ios_football_appUITests: XCTestCase {
  
  private var app: XCUIApplication!
  
  override func setUp() {
    app = .init()
    stubAPI()
    app.launch()
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    app = nil
  }
  
  func testExample() {
    let teamsTab = app.tabBars.buttons.matching(identifier: ElementIdentifier.teamsTabBar.rawValue).firstMatch
    XCTAssertTrue(teamsTab.exists)
    teamsTab.tap()
    let tableView = app.descendants(matching: .table).firstMatch
    let cell = tableView.staticTexts["Team Royal Knights"]
    while !cell.exists {
      app.swipeUp()
    }
    cell.tap()
  }
  
  private func stubAPI() {
    stub(condition: isAbsoluteURLString("https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams")) { _ in
      let stubPath = OHPathForFile("teams.json", type(of: self))
      return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
    }
    stub(condition: isAbsoluteURLString("https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams/matches")) { _ in
      let stubPath = OHPathForFile("matches.json", type(of: self))
      return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
    }
  }
}
