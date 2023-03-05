//
//  MatchListViewModelTests.swift
//  ios-football-appTests
//
//  Created by Kelvin Fok on 5/3/23.
//

import XCTest
import Combine
@testable import ios_football_app

final class MatchListViewModelTests: XCTestCase {
  
  private var sut: MatchListViewModel!
  private var matchListService: MatchListServiceMock!
  private var teamListService: TeamListServiceMock!
  
  private let inputSubject = PassthroughSubject<MatchListViewModel.Input, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  override func setUp() {
    matchListService = .init()
    teamListService = .init()
    sut = .init(matchListService: matchListService, teamListService: teamListService)
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    matchListService = nil
    teamListService = nil
  }
  
  func testDisplayMatches_onViewDidLoad_isCalled() {
    // given
    let output = buildOutput()
    let exp = XCTestExpectation(description: "display matches should show")
    let match: Match = .init(
      date: "2022-04-23T18:00:00.000Z",
      description: "Team Cool Eagles vs. Team Red Dragons",
      home: "Team Cool Eagles",
      away: "Team Red Dragons",
      winner: "Team Red Dragons",
      highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4")
    matchListService.fetchListMockValue = [
      match
    ]
    teamListService.fetchListMockValue = [
      .init(id: "1", name: "Team Cool Eagles", logo: "https://tstzj.s3.amazonaws.com/eagles.png"),
      .init(id: "2", name: "Team Red Dragons", logo: "https://tstzj.s3.amazonaws.com/dragons.png")
    ]
    // then
    output.sink { event in
      switch event {
      case .displayError:
        XCTFail("not expecting display error")
      case .displayMatches(let matches):
        exp.fulfill()
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0].match, match)
      case .openVideoPlayer:
        XCTFail("not expecting open video player")
      }
    }.store(in: &cancellables)
    // when
    inputSubject.send(.viewDidLoad)
    wait(for: [exp], timeout: 0.1)
  }
  
  func testOpenVideoPlayer_onCellSelection_isCalled() {
    // given
    let output = buildOutput()
    let exp = XCTestExpectation(description: "openVideoPlayer should show")
    let match: Match = .init(
      date: "2022-04-23T18:00:00.000Z",
      description: "Team Cool Eagles vs. Team Red Dragons",
      home: "Team Cool Eagles",
      away: "Team Red Dragons",
      winner: "Team Red Dragons",
      highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4")
    matchListService.fetchListMockValue = [
      match
    ]
    teamListService.fetchListMockValue = [
      .init(id: "1", name: "Team Cool Eagles", logo: "https://tstzj.s3.amazonaws.com/eagles.png"),
      .init(id: "2", name: "Team Red Dragons", logo: "https://tstzj.s3.amazonaws.com/dragons.png")
    ]
    // then
    output.sink { event in
      switch event {
      case .displayError:
        XCTFail("not expecting display error")
      case .displayMatches:
        XCTFail("not expecting display matches")
      case .openVideoPlayer(let url):
        exp.fulfill()
        XCTAssertEqual(url.absoluteString, match.highlights)
      }
    }.store(in: &cancellables)
    // when
    let model: MatchCell.Model = .init(
      match: match,
      homeTeamImageURL: "https://tstzj.s3.amazonaws.com/eagles.png",
      awayTeamImageURL: "https://tstzj.s3.amazonaws.com/dragons.png")
    inputSubject.send(.cellDidTap(model))
    wait(for: [exp], timeout: 0.1)
  }
  
  func testDisplayMatches_onSearch_isCalled() {
    // given
    let output = buildOutput()
    let exp = XCTestExpectation(description: "display matches should show")
    let match1: Match = .init(
      date: "2022-04-23T18:00:00.000Z",
      description: "Team Cool Eagles vs. Team Red Dragons",
      home: "Team Cool Eagles",
      away: "Team Red Dragons",
      winner: "Team Red Dragons",
      highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4")
    let match2: Match = .init(
      date: "2022-04-23T18:00:00.000Z",
      description: "Team Royal Knights vs. Team Red Dragons",
      home: "Team Royal Knights",
      away: "Team Red Dragons",
      winner: "Team Red Dragons",
      highlights: "https://tstzj.s3.amazonaws.com/highlights.mp4")
    matchListService.fetchListMockValue = [
      match1,
      match2
    ]
    teamListService.fetchListMockValue = [
      .init(id: "1", name: "Team Cool Eagles", logo: "https://tstzj.s3.amazonaws.com/eagles.png"),
      .init(id: "2", name: "Team Red Dragons", logo: "https://tstzj.s3.amazonaws.com/dragons.png"),
      .init(id: "3", name: "Team Royal Knights", logo: "https://tstzj.s3.amazonaws.com/knights.png")
    ]
    var matchesCount: [Int] = []
    // then
    output.sink { event in
      switch event {
      case .displayError:
        XCTFail("not expecting display error")
      case .displayMatches(let matches):
        matchesCount.append(matches.count)
        exp.fulfill()
      case .openVideoPlayer:
        XCTFail("not expecting open video player")
      }
    }.store(in: &cancellables)
    // when
    inputSubject.send(.viewDidLoad)
    inputSubject.send(.search("knights"))
    wait(for: [exp], timeout: 0.1)
    XCTAssertEqual(matchesCount, [2,1])
  }
  
  private func buildOutput() -> AnyPublisher<MatchListViewModel.Output, Never> {
    return sut.transform(input: inputSubject.eraseToAnyPublisher())
  }
}
