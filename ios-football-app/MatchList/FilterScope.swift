//
//  FilterScope.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation

enum FilterScope: Int, CaseIterable {
  case none
  case upcoming
  case previous
  var stringValue: String {
    switch self {
    case .none:
      return "all"
    case .upcoming:
      return "upcoming"
    case .previous:
      return "previous"
    }
  }
}
