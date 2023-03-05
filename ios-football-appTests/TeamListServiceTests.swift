//
//  TeamListServiceTests.swift
//  ios-football-appTests
//
//  Created by Kelvin Fok on 5/3/23.
//

import XCTest
import Combine
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import ios_football_app

final class TeamListServiceTests: XCTestCase {
  private var sut: TeamListService!
  private var offlineTeamListService: OfflineTeamListServiceMock!
  
  private var cancellables = Set<AnyCancellable>()
  
  override func setUp() {
    offlineTeamListService = .init()
    sut = .init(offlineTeamListService: offlineTeamListService)
    super.setUp()
  }
  
  override func tearDown()  {
    super.tearDown()
    sut = nil
    offlineTeamListService = nil
  }
  
  func testFetchListHappyPath() {
    // given
    let status: Int32 = 200
    stub(condition: isAbsoluteURLString("https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams")) { _ in
      let stubPath = OHPathForFile("teams.json", type(of: self))
      return fixture(filePath: stubPath!, status: status, headers: ["Content-Type":"application/json"])
    }
    let exp = XCTestExpectation(description: "fetch list should be called")
    // when
    sut.fetchList().sink { teams in
      exp.fulfill()
      XCTAssertEqual(teams.count, 10)
      XCTAssertEqual(teams[0].id, "767ec50c-7fdb-4c3d-98f9-d6727ef8252b")
    }.store(in: &cancellables)
    // then
    wait(for: [exp], timeout: 0.1)
  }
  
  func testOfflineTeamListService_onFailedRemoteAPICall_isCalled() {
    // given
    let status: Int32 = 500
    stub(condition: isAbsoluteURLString("https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams")) { _ in
      let stubPath = OHPathForFile("error.json", type(of: self))
      return fixture(filePath: stubPath!, status: status, headers: ["Content-Type":"application/json"])
    }
    offlineTeamListService.fetchTeamsMockValue = [
      .init(id: "101", name: "Team Apple", logo: "https://image.com/apple.png"),
      .init(id: "102", name: "Team Banana", logo: "https://image.com/banana.png"),
    ]
    let exp = XCTestExpectation(description: "fetch list should be called")
    // when
    sut.fetchList().sink { teams in
      exp.fulfill()
      XCTAssertEqual(teams.count, 2)
      XCTAssertEqual(teams[0].name, "Team Apple")
      XCTAssertEqual(teams[0].id, "101")
    }.store(in: &cancellables)
    // then
    wait(for: [exp], timeout: 0.1)
  }
}
