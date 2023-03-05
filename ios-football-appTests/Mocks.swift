//
//  TeamListServiceMock.swift
//  ios-football-appTests
//
//  Created by Kelvin Fok on 5/3/23.
//

import Foundation
import Combine
@testable import ios_football_app

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

final class MatchListServiceMock: MatchListServiceType {
  var fetchListMockValue: [Match]?
  func fetchList() -> AnyPublisher<[Match], Never> {
    if let matches = fetchListMockValue {
      return Just(matches).eraseToAnyPublisher()
    } else {
      return Empty().eraseToAnyPublisher()
    }
  }
}

final class OfflineTeamListServiceMock: OfflineTeamListServiceType {
  
  var createTeamArray: [Team] = []
  func createTeams(teams: [Team]) {
    createTeamArray.append(contentsOf: teams)
  }
  
  var fetchTeamsMockValue: [Team]?
  func fetchTeams(completion: @escaping ([Team]) -> Void) {
    if let teams = fetchTeamsMockValue {
      completion(teams)
    }
  }
  
  var deleteTeamsCounter = 0
  func deleteTeams() {
    deleteTeamsCounter += 1
  }
}
