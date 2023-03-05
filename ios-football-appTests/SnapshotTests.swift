//
//  SnapshotTests.swift
//  ios-football-appTests
//
//  Created by Kelvin Fok on 4/3/23.
//

import Foundation
import XCTest
import SDWebImage
import SnapshotTesting
@testable import ios_football_app

final class SnapshotTests: XCTestCase {
  
  func testDateView() {
    // given
    let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    let view = DateView(frame: frame)
    // when
    view.configure(date: .init(timeIntervalSince1970: 99999))
    // then
    assertSnapshot(matching: view, as: .image)
  }
  
  func testTeamView_isWinner() {
    // given
    let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    let view = TeamView(frame: frame)
    // when
    view.configure(
      name: "Manchester United",
      imageURL: nil,
      isWinner: true)
    // then
    assertSnapshot(matching: view, as: .image)
  }
  
  func testTeamView_isLoser() {
    // given
    let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    let view = TeamView(frame: frame)
    // when
    view.configure(
      name: "Manchester United",
      imageURL: nil,
      isWinner: false)
    // then
    assertSnapshot(matching: view, as: .image)
  }
  
  func testTeamCell() {
    // given
    let frame = CGRect(x: 0, y: 0, width: 500, height: 120)
    let view = TeamCell(style: .default, reuseIdentifier: nil)
    view.bounds = frame
    let team = Team(
      id: "123",
      name: "Liverpool FFC",
      logo: "")
    // when
    view.configure(team: team)
    // then
    assertSnapshot(matching: view, as: .image)
  }
  
  func testMatchCell() {
    // given
    let frame = CGRect(x: 0, y: 0, width: 500, height: 120)
    let match: Match = .init(
      date: "2022-04-23T18:00:00.000Z",
      description: "Team Cool Eagles vs. Team Red Dragons",
      home: "Team Cool Eagles",
      away: "Team Red Dragons",
      winner: "Team Red Dragons",
      highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4")
    let model: MatchCell.Model = .init(
      match: match,
      homeTeamImageURL: nil,
      awayTeamImageURL: nil)
    // when
    let view = MatchCell(frame: frame)
    view.configure(model: model)
    // then
    assertSnapshot(matching: view, as: .image)
  }
}
