//
//  MatchListService.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation
import Combine

protocol MatchListServiceType {
  func fetchList() -> AnyPublisher<[Match], Never>
}

class MatchListService: MatchListServiceType {
  
  private let offlineMatchListService: OfflineMatchListServiceType
  
  init(offlineMatchListService: OfflineMatchListServiceType = CoreDataManager.shared) {
    self.offlineMatchListService = offlineMatchListService
  }
  
  func fetchList() -> AnyPublisher<[Match], Never> {
    return URLSession
      .shared
      .dataTaskPublisher(
        for: URL(string: "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams/matches")!)
      .map { $0.data }
      .decode(type: MatchesResponse.self, decoder: JSONDecoder())
      .map { $0.matches.previous + $0.matches.upcoming }
      .catch { _ in
        return Future<[Match], Never> { [weak self] promise in
          self?.loadOffline { matches in
            promise(.success(matches))
          }
        }
      }
      .handleEvents(receiveOutput: { [weak self] matches in
        self?.saveOffline(matches: matches)
      })
      .eraseToAnyPublisher()
  }
  
  private func loadOffline(completion: @escaping ([Match]) -> Void) {
    offlineMatchListService.fetchMatches { matches in
      completion(matches)
    }
  }
  
  private func saveOffline(matches: [Match]) {
    offlineMatchListService.deleteMatches()
    offlineMatchListService.createMatches(matches: matches)
  }
}
