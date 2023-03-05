//
//  CoreDataManager.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 4/3/23.
//

import Foundation
import CoreData

protocol OfflineMatchListServiceType {
  func createMatches(matches: [Match])
  func fetchMatches(completion: @escaping ([Match]) -> Void)
  func deleteMatches()
}

protocol OfflineTeamListServiceType {
  func createTeams(teams: [Team])
  func fetchTeams(completion: @escaping ([Team]) -> Void)
  func deleteTeams()
}

class CoreDataManager {
  
  static let shared = CoreDataManager()
  
  private let container: NSPersistentContainer
  
  private init() {
    container = NSPersistentContainer(name: "ios_football_app")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        print("core data error \(error), \(error.userInfo)")
      }
    }
  }
}

extension CoreDataManager: OfflineMatchListServiceType {
  
  func createMatches(matches: [Match]) {
    container.performBackgroundTask { context in
      for match in matches {
        let cdMatch = CDMatch(context: context)
        cdMatch.date = match.date
        cdMatch.description_ = match.description
        cdMatch.home = match.home
        cdMatch.away = match.away
        if let winner = match.winner {
          cdMatch.winner = winner
        }
        if let highlights = match.highlights {
          cdMatch.highlights = highlights
        }
      }
      if context.hasChanges {
        try? context.save()
      }
    }
  }
    
  func fetchMatches(completion: @escaping ([Match]) -> Void) {
    let context = container.viewContext
    context.perform {
      let request: NSFetchRequest<CDMatch> = CDMatch.fetchRequest()
        guard let cdMatches: [CDMatch] = try? context.fetch(request) else {
          completion([])
          return
        }
        let matches = cdMatches.map { match in
          return Match(
            date: match.date!,
            description: match.description_!,
            home: match.home!,
            away: match.away!,
            winner: match.winner,
            highlights: match.highlights)
        }
        completion(matches)
    }
  }
  
  func deleteMatches() {
    let context = container.viewContext
    let request: NSFetchRequest<CDMatch> = CDMatch.fetchRequest()
    guard let cdMatches = try? context.fetch(request) else { return }
    cdMatches.forEach {
      context.delete($0)
    }
    try? context.save()
  }
}

extension CoreDataManager: OfflineTeamListServiceType {
  
  func createTeams(teams: [Team]) {
    container.performBackgroundTask { context in
      for team in teams {
        let cdTeam = CDTeam(context: context)
        cdTeam.id = team.id
        cdTeam.logo = team.logo
        cdTeam.name = team.name
      }
      if context.hasChanges {
        try? context.save()
      }
    }
  }
  
  func fetchTeams(completion: @escaping ([Team]) -> Void) {
    let context = container.viewContext
    context.perform {
      let request: NSFetchRequest<CDTeam> = CDTeam.fetchRequest()
      guard let cdTeams = try? context.fetch(request) else {
        completion([])
        return
      }
      let teams: [Team] = cdTeams.map {
        .init(
          id: $0.id ?? "NA",
          name: $0.name ?? "NA",
          logo: $0.logo ?? "NA")
      }
      completion(teams)
    }
  }
  
  func deleteTeams() {
    let context = container.viewContext
    let request: NSFetchRequest<CDTeam> = CDTeam.fetchRequest()
    guard let cdTeams = try? context.fetch(request) else { return }
    cdTeams.forEach {
      context.delete($0)
    }
    try? context.save()
  }
}
