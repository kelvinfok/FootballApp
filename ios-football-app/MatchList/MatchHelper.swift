//
//  MatchHelper.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation

struct MatchHelper {
  static func checkType(match: Match) -> MatchType {
    if match.winner == nil && match.highlights == nil {
      return .upcoming
    }
    return .previous
  }
  
  static func checkWinner(match: Match) -> MatchWinner? {
    if match.winner == match.home {
      return .home
    } else if match.winner == match.away {
      return .away
    } else {
       return nil
    }
  }
  
  static func checkResult(match: Match, team: Team) -> MatchResult {
    if match.winner == team.name {
      return .won
    } else if match.home == team.name || match.away == team.name {
      return .lost
    } else {
      return .notPlayed
    }
  }
  
  static func formatDate(dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: dateString)
  }
}
