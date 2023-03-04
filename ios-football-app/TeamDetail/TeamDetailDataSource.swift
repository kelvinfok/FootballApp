//
//  TeamDetailDataSource.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 4/3/23.
//

import UIKit

class TeamDetailDataSource: UITableViewDiffableDataSource<TeamDetailController.Section, Match> {
  
  private let teamStats: TeamStats
  
  init(teamStats: TeamStats, tableView: UITableView) {
    self.teamStats = teamStats
    super.init(tableView: tableView) { tableView, indexPath, match in
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TeamStatsCell.identifier,
        for: indexPath) as? TeamStatsCell ?? TeamStatsCell()
      switch indexPath.section {
      case 0:
        cell.configure(match: match, result: .won)
      case 1:
        cell.configure(match: match, result: .lost)
      default: break
      }
      cell.accessoryType = .disclosureIndicator
      return cell
    }
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return String(
      format: "%@ - (%d)",
      snapshot().sectionIdentifiers[section].rawValue,
      snapshot().itemIdentifiers(inSection: snapshot().sectionIdentifiers[section]).count)
  }
}
