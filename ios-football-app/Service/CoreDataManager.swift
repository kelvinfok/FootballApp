//
//  CoreDataManager.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 4/3/23.
//

import Foundation
import CoreData

protocol OfflineMatchListServiceType {
  func createMatches(matches: [Match]) throws
  func fetchMatches() throws -> [Match]
  func deleteMatches() throws
}

protocol OfflineTeamListServiceType {
  func createTeam(team: Team) throws
  func fetchTeams() throws -> [Team]
  func deleteTeams() throws
}

class CoreDataManager {
  
  enum Entity: String {
    case match = "CDMatch"
  }
  
  enum CoreDataError: Error {
    case invalidEntity
  }
  
  static let shared = CoreDataManager()
  
  private let container: NSPersistentContainer
  private var context: NSManagedObjectContext {
    container.viewContext
  }
  
  var error: Error?
  
  private init() {
    container = NSPersistentContainer(name: "ios_football_app")
  }
  
  func setup() {
    container.loadPersistentStores { [weak self] description, error in
      if let error = error as NSError? {
        print("core data error \(error), \(error.userInfo)")
        self?.error = error
      }
    }
  }
  
  private func saveContext() throws {
    if context.hasChanges {
      try context.save()
    }
  }
  
  private func throwErrorIfNeeded() throws {
    if let error = error {
      throw error
    }
  }
}

extension CoreDataManager: OfflineMatchListServiceType {
  
  func createMatches(matches: [Match]) throws {
    try matches.forEach { match in
      guard let entity = NSEntityDescription
        .insertNewObject(
          forEntityName: Entity.match.rawValue,
          into: context) as? CDMatch
      else { throw CoreDataError.invalidEntity }
      entity.date = match.date
      entity.description_ = match.description
      entity.home = match.home
      entity.away = match.away
      if let winner = match.winner {
        entity.winner = winner
      }
      if let highlights = match.highlights {
        entity.highlights = highlights
      }
    }
    try saveContext()
  }
    
  func fetchMatches() throws -> [Match] {
    let request = NSFetchRequest<CDMatch>(entityName: Entity.match.rawValue)
    let cdMatches = try context.fetch(request)
    return cdMatches.map {
      .init(date: $0.date ?? "NA",
            description: $0.description_ ?? "NA",
            home: $0.home ?? "NA",
            away: $0.away ?? "NA",
            winner: $0.winner ?? "NA",
            highlights: $0.highlights ?? "NA")
    }
  }
  
  func deleteMatches() throws {
    let request = NSFetchRequest<CDMatch>(entityName: "CDMatch")
    let cdMatches = try context.fetch(request)
    cdMatches.forEach {
      context.delete($0)
    }
    try context.save()
  }
}

extension CoreDataManager: OfflineTeamListServiceType {
  func createTeam(team: Team) throws {
    let cdTeam = NSEntityDescription.insertNewObject(forEntityName: "CDTeam", into: context) as! CDTeam
    cdTeam.name = team.name
    cdTeam.id = team.id
    cdTeam.logo = team.logo
    try context.save()
  }
  
  func fetchTeams() throws -> [Team] {
    let request = NSFetchRequest<CDTeam>(entityName: "CDTeam")
    let cdTeams = try context.fetch(request)
    return cdTeams.map {
      .init(
        id: $0.id ?? "NA",
        name: $0.name ?? "NA",
        logo: $0.logo ?? "NA")
    }
  }
  
  func deleteTeams() throws {
    let request = NSFetchRequest<CDTeam>(entityName: "CDTeam")
    let cdTeams = try context.fetch(request)
    cdTeams.forEach {
      context.delete($0)
    }
    try context.save()
  }
}
