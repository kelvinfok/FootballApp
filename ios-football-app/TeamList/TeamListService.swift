//
//  TeamListService.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation
import Combine

protocol TeamListServiceType {
  func fetchList() -> AnyPublisher<[Team], Error>
}

class TeamListService: TeamListServiceType {
  func fetchList() -> AnyPublisher<[Team], Error> {
    let url = URL(string: "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams")!
    return URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: TeamsResponse.self, decoder: JSONDecoder())
      .map { $0.teams }
      .eraseToAnyPublisher()
  }
}
