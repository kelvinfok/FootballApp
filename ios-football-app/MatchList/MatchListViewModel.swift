//
//  MatchListViewModel.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation
import Combine

class MatchListViewModel {
  
  enum Input {
    case viewDidLoad
    case cellDidTap(MatchCell.Model)
    case search(String)
    case scopeDidUpdate(FilterScope)
  }
  
  enum Output {
    case displayMatches([MatchCell.Model])
    case openVideoPlayer(url: URL)
  }
  
  private var outputSubject: PassthroughSubject<Output, Never> = .init()
  private var cancellables = Set<AnyCancellable>()
  
  // States
  @Published private var matches: [Match] = []
  @Published private var teams: [Team] = []
  @Published private var query: String = ""
  @Published private var scope: FilterScope = .none
  
  // Dependencies
  private let matchListService: MatchListServiceType
  private let teamListService: TeamListServiceType
  
  init(matchListService: MatchListServiceType = MatchListService(),
       teamListService: TeamListServiceType = TeamListService()) {
    self.matchListService = matchListService
    self.teamListService = teamListService
    observe()
  }
  
  func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
    input.sink { [weak self] event in
      switch event {
      case .viewDidLoad:
        self?.handleViewDidLoad()
      case .cellDidTap(let model):
        self?.handleCellDidTap(model: model)
      case .search(let query):
        self?.handleSearch(query: query)
      case .scopeDidUpdate(let scope):
        self?.handleScopeDidUpdate(scope: scope)
      }
    }.store(in: &cancellables)
    return outputSubject.eraseToAnyPublisher()
  }
  
  private func handleScopeDidUpdate(scope: FilterScope) {
    self.scope = scope
  }
  
  private func handleSearch(query: String) {
    self.query = query
  }
  
  private func handleCellDidTap(model: MatchCell.Model) {
    guard let urlString = model.match.highlights,
            let url = URL(string: urlString) else { return }
    outputSubject.send(.openVideoPlayer(url: url))
  }
  
  private func handleViewDidLoad() {
    matchListService.fetchList().sink { [weak self] matches in
      self?.matches = matches
    }.store(in: &cancellables)
    
    teamListService.fetchList().sink { [weak self] teams in
      self?.teams = teams
    }.store(in: &cancellables)
  }
  
  private func observe() {
    Publishers.CombineLatest4(
      $matches,
      $teams,
      $query,
      $scope)
    .filter { return ($0.0.isEmpty == false && $0.1.isEmpty == false) }
    .sink { [weak self] (matches, teams, query, scope) in
      let teamDict = self?.dictionaryFrom(teams: teams) ?? [:]
      let filteredMatches: [Match] = matches
        .filter { match in
          guard !query.isEmpty else { return true }
          return (match.home.lowercased().contains(query.lowercased()) || match.away.lowercased().contains(query.lowercased()))
        }
        .filter { match in
          switch scope {
          case .none:
            return true
          case .upcoming:
            return MatchHelper.checkType(match: match) == .upcoming
          case .previous:
            return MatchHelper.checkType(match: match) == .previous
          }
        }
      let models: [MatchCell.Model] = filteredMatches.map { match in
        .init(
          match: match,
          homeTeamImageURL: teamDict[match.home],
          awayTeamImageURL: teamDict[match.away])
      }
      self?.outputSubject.send(.displayMatches(models))
    }.store(in: &cancellables)
  }
  
  private func dictionaryFrom(teams: [Team]) -> [String: String] {
    var dict: [String: String] = [:]
    teams.forEach {
      dict[$0.name] = $0.logo
    }
    return dict
  }
}
