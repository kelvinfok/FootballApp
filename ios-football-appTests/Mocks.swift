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
  func createTeam(team: Team) throws {
    createTeamArray.append(team)
  }
  
  var fetchTeamsMockValue: [Team]?
  var fetchTeamsError: Error?
  func fetchTeams() throws -> [Team] {
    if let value = fetchTeamsMockValue {
      return value
    }
    if let error = fetchTeamsError {
      throw error
    }
    return []
  }
  
  var deleteTeamsCounter = 0
  func deleteTeams() throws {
    deleteTeamsCounter += 1
  }
}
