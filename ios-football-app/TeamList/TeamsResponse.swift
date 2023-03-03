//
//  TeamsResponse.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import Foundation

struct TeamsResponse: Decodable {
  let teams: [Team]
}

struct Team: Decodable, Hashable {
  let id: String
  let name: String
  let logo: String
}
