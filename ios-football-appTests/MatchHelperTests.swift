//
//  MatchHelperTests.swift
//  ios-football-appTests
//
//  Created by Kelvin Fok on 6/3/23.
//

import XCTest
@testable import ios_football_app

final class MatchHelperTests: XCTestCase {
  
  func testMatchResult() {
    // given
    let match = Match(
      date: "2022-05-17T18:00:00.000Z",
      description: "Team Red Dragons vs. Team Growling Tigers",
      home: "Team Red Dragons",
      away: "Team Growling Tigers",
      winner: "Team Growling Tigers",
      highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4")
    let team = Team(
      id: "22e4fd58-eb8c-11ec-8ea0-0242ac120002",
      name: "Team Growling Tigers",
      logo: "https://tstzj.s3.amazonaws.com/tiger.png")
    // when
    let result = MatchHelper.checkResult(
      match: match,
      team: team)
    // then
    XCTAssertEqual(result, .won)
  }
  
  func testMatchType() {
    // given
    let match = Match(
      date: "2022-05-17T18:00:00.000Z",
      description: "Team Red Dragons vs. Team Growling Tigers",
      home: "Team Red Dragons",
      away: "Team Growling Tigers",
      winner: "Team Growling Tigers",
      highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4")
    // when
    let type = MatchHelper.checkType(match: match)
    // when
    XCTAssertEqual(type, .previous)
  }
  
  func testMatchWinner() {
    // given
    let match = Match(
      date: "2022-05-17T18:00:00.000Z",
      description: "Team Red Dragons vs. Team Growling Tigers",
      home: "Team Red Dragons",
      away: "Team Growling Tigers",
      winner: "Team Growling Tigers",
      highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4")
    // when
    let winner = MatchHelper.checkWinner(match: match)
    // then
    XCTAssertEqual(winner, .away)
  }
  
  func testDateFormat() {
    // given
    let dateString = "2022-05-17T18:00:00.000Z"
    // when
    let date = MatchHelper.formatDate(dateString: dateString)
    let format = date?.formatted(date: .abbreviated, time: .shortened)
    // then
    XCTAssertEqual(format, "May 18, 2022 at 2:00 AM")
  }
}
