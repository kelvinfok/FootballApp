//
//  MatchesResponse.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation

struct MatchesResponse: Hashable, Decodable {
  let matches: Matches
}

struct Matches: Hashable, Decodable {
  let previous: [Match]
  let upcoming: [Match]
}

struct Match: Hashable, Decodable {
  let date: String
  let description: String
  let home: String
  let away: String
  let winner: String?
  let highlights: String?
}

enum MatchType {
  case previous
  case upcoming
}

enum MatchWinner {
  case home
  case away
}

enum MatchResult: String {
  case notPlayed
  case won
  case lost
}
