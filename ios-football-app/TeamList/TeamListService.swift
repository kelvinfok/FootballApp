//
//  TeamListService.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation
import Combine

protocol TeamListServiceType {
  func fetchList() -> AnyPublisher<[Team], Never>
}

class TeamListService: TeamListServiceType {
  
  private let offlineTeamListService: OfflineTeamListServiceType
  
  init(offlineTeamListService: OfflineTeamListServiceType = CoreDataManager.shared) {
    self.offlineTeamListService = offlineTeamListService
  }
  
  func fetchList() -> AnyPublisher<[Team], Never> {
    let url = URL(string: "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams")!
    return URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: TeamsResponse.self, decoder: JSONDecoder())
      .map { $0.teams }
      .replaceError(with: loadOffline())
      .handleEvents(receiveOutput: { [weak self] teams in
        self?.saveOffline(teams: teams)
      })
      .eraseToAnyPublisher()
  }
  
  private func loadOffline() -> [Team] {
    let teams = (try? offlineTeamListService.fetchTeams()) ?? []
    print(">>> offline teams: \(teams.count)")
    return teams
  }

  private func saveOffline(teams: [Team]) {
    try! offlineTeamListService.deleteTeams()
    teams.forEach { team in
      try! offlineTeamListService.createTeam(team: team)
    }
  }
}
