//
//  TeamDetailViewModel.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 4/3/23.
//

import Foundation
import Combine

class TeamDetailViewModel {
  
  private let matchService = MatchListService()
  private var cancellables = Set<AnyCancellable>()
  
  private let outputSubject = PassthroughSubject<Output, Never>()
  var outputPublisher: AnyPublisher<Output, Never> {
    outputSubject.eraseToAnyPublisher()
  }
  
  private let team: Team
  
  init(team: Team) {
    self.team = team
  }
  
  enum Output {
    case setDataSource(TeamStats)
    case setNavigationTitle(String)
    case openVideoPlayer(url: URL)
  }
  
  func onViewDidLoad() {
    matchService.fetchList().sink { [weak self] matches in
      self?.handleMatches(matches: matches)
    }.store(in: &cancellables)
    handleSetNavigationTitle()
  }
  
  func onMatchDidSelect(match: Match) {
    guard let urlString = match.highlights,
          let url = URL(string: urlString) else { return }
    outputSubject.send(.openVideoPlayer(url: url))
  }
  
  private func handleMatches(matches: [Match]) {
    let wins = matches.filter {
      MatchHelper.checkResult(match: $0, team: team) == .won
    }
    let losses = matches.filter {
      MatchHelper.checkResult(match: $0, team: team) == .lost
    }
    let stats = TeamStats(wins: wins, losses: losses)
    outputSubject.send(.setDataSource(stats))
  }
  
  private func handleSetNavigationTitle() {
    let formatted = String(format: "%@ Stats", team.name)
    outputSubject.send(.setNavigationTitle(formatted))
  }
}
