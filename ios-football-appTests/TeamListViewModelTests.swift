//
//  TeamListViewModelTests.swift
//  ios-football-appTests
//
//  Created by Kelvin Fok on 4/3/23.
//

import XCTest
import Combine
@testable import ios_football_app

final class TeamListViewModelTests: XCTestCase {
  
  private var sut: TeamListViewModel!
  private var teamListService: TeamListServiceMock!
  
  private let viewDidLoadEvent = PassthroughSubject<Void, Never>()
  private let teamDidSelectEvent = PassthroughSubject<Team, Never>()
  
  private var cancellables = Set<AnyCancellable>()
  
  override func setUp() {
    teamListService = .init()
    sut = .init(teamListService: teamListService)
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
    teamListService = nil
  }
  
  func testSetDataSource_onVieDidLoad_isCalled() {
    // given
    let output = buildOutput()
    let exp = XCTestExpectation(description: "setDataSource to be called")
    teamListService.fetchListMockValue = [.init(id: "1", name: "name", logo: "logo")]
    // then
    output.setDataSource.sink { completion in
      if case .failure = completion {
        XCTFail("not expecting failure")
      }
    } receiveValue: { teams in
      exp.fulfill()
      XCTAssertEqual(teams.count, 1)
      XCTAssertEqual(teams[0].id, "1")
      XCTAssertEqual(teams[0].name, "name")
      XCTAssertEqual(teams[0].logo, "logo")
    }.store(in: &cancellables)
    // when
    viewDidLoadEvent.send()
    wait(for: [exp], timeout: 0.1)
  }
  
  private func buildOutput() -> TeamListViewModel.Output {
    let input = TeamListViewModel.Input(
      viewDidLoad: viewDidLoadEvent.eraseToAnyPublisher(),
      teamDidSelect: teamDidSelectEvent.eraseToAnyPublisher())
    let output = sut.transform(input: input)
    return output
  }
  
  
}

final class TeamListServiceMock: TeamListServiceType {
  var fetchListMockValue: [Team]?
  func fetchList() -> AnyPublisher<[Team], Never> {
    if let team = fetchListMockValue {
      return Just(team).eraseToAnyPublisher()
    } else {
      return Empty().eraseToAnyPublisher()
    }
  }
}
