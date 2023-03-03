//
//  TeamDetailController.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import UIKit
import Combine

struct TeamStats: Hashable {
  let wins: [Match]
  let losses: [Match]
}

class TeamDetailViewModel {
  
  private let matchService = MatchListService()
  private var cancellables = Set<AnyCancellable>()
  
  private let outputSubject = PassthroughSubject<Output, Never>()
  var outputPublisher: AnyPublisher<Output, Never> {
    outputSubject.eraseToAnyPublisher()
  }
  
  private let team: Team
  
  init(team: Team) {
    self.team = team
  }
  
  enum Output {
    case setDataSource(TeamStats)
    case setNavigationTitle(String)
  }
  
  func onViewDidLoad() {
    matchService.fetchList().sink { completion in
      
    } receiveValue: { [weak self] matches in
      self?.handleMatches(matches: matches)
    }.store(in: &cancellables)
    handleSetNavigationTitle()
  }
  
  private func handleMatches(matches: Matches) {
    let all: [Match] = matches.previous + matches.upcoming
    let wins = all.filter {
      MatchHelper.checkResult(match: $0, team: team) == .won
    }
    let losses = all.filter {
      MatchHelper.checkResult(match: $0, team: team) == .lost
    }
    let stats = TeamStats(wins: wins, losses: losses)
    outputSubject.send(.setDataSource(stats))
  }
  
  private func handleSetNavigationTitle() {
    let formatted = String(format: "%@ Stats", team.name)
    outputSubject.send(.setNavigationTitle(formatted))
  }
}

enum Section {
  case win
  case lose
}

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

class TeamDetailController: UITableViewController {
  
  private let viewModel: TeamDetailViewModel
  private var cancellables = Set<AnyCancellable>()
  
  private var teamStats: TeamStats!
  
  init(viewModel: TeamDetailViewModel) {
    self.viewModel = viewModel
    super.init(style: .grouped)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  enum Section: String {
    case wins
    case losses
  }
  
  private lazy var dataSource = TeamDetailDataSource(teamStats: teamStats, tableView: tableView)
  
  override func loadView() {
    super.loadView()
    observe()
    setupTableView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.onViewDidLoad()
  }
  
  private func observe() {
    viewModel.outputPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] event in
      switch event {
      case .setNavigationTitle(let title):
        self?.navigationItem.title = title
        self?.navigationItem.largeTitleDisplayMode = .always
      case .setDataSource(let teamStats):
        self?.teamStats = teamStats
        self?.applySnapshot()
      }
    }.store(in: &cancellables)
  }
  
  private func setupTableView() {
    tableView.backgroundColor = .white
    tableView.register(TeamStatsCell.self, forCellReuseIdentifier: TeamStatsCell.identifier)
  }

  private func applySnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Match>()
    snapshot.appendSections([.wins, .losses])
    snapshot.appendItems(teamStats.wins, toSection: .wins)
    snapshot.appendItems(teamStats.losses, toSection: .losses)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

class TeamStatsCell: UITableViewCell {
  static let identifier = String(describing: TeamStatsCell.self)
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .light)
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .gray
    return label
  }()
  
  private let resultLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .bold)
    label.textColor = .darkText
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      descriptionLabel,
      dateLabel,
      resultLabel
    ])
    stackView.spacing = 8
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(match: Match, result: MatchResult) {
    descriptionLabel.text = match.description
    var formattedDateString: String {
      guard let date = MatchHelper.formatDate(dateString: match.date) else { return "N/A"}
      return date.formatted(date: .abbreviated, time: .omitted)
    }
    dateLabel.text = formattedDateString
    resultLabel.text = result.rawValue.uppercased()
  }
  
  private func layout() {
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }
}
