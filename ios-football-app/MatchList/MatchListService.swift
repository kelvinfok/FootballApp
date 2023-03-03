//
//  MatchListService.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation
import Combine

protocol MatchListServiceType {
  func fetchList() -> AnyPublisher<Matches, Error>
}

class MatchListService: MatchListServiceType {
  func fetchList() -> AnyPublisher<Matches, Error> {
    let url = URL(string: "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams/matches")!
    return URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: MatchesResponse.self, decoder: JSONDecoder())
      .map { $0.matches }
      .eraseToAnyPublisher()
  }
}
