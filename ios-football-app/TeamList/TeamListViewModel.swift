//
//  TeamsViewModel.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import UIKit
import Combine

class TeamListViewModel {
  
  struct Input {
    let viewDidLoad: AnyPublisher<Void, Never>
    let teamDidSelect: AnyPublisher<Team, Never>
  }
  
  class Output {
    let setDataSource: AnyPublisher<[Team], Error>
    let showTeamDetail: AnyPublisher<Team, Never>
    init(setDataSource: AnyPublisher<[Team], Error>,
         showTeamDetail: AnyPublisher<Team, Never>) {
      self.setDataSource = setDataSource
      self.showTeamDetail = showTeamDetail
    }
  }
  
  private let teamListService: TeamListServiceType
  
  init(teamListService: TeamListServiceType = TeamListService()) {
    self.teamListService = teamListService
  }
  
  func transform(input: Input) -> Output {
    let setDataSource = input.viewDidLoad
      .setFailureType(to: Error.self)
      .flatMap { [weak self] in
        return self?.teamListService.fetchList() ?? Empty().eraseToAnyPublisher()
      }.eraseToAnyPublisher()
    let showTeamDetail = input.teamDidSelect.flatMap { team in
      return Just(team)
    }.eraseToAnyPublisher()
    return .init(
      setDataSource: setDataSource,
      showTeamDetail: showTeamDetail)
  }
}
