//
//  TeamsController.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 2/3/23.
//

import UIKit
import Combine

class TeamsController: UITableViewController {
  
  private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
  private let teamDidSelectSubject = PassthroughSubject<Team, Never>()
  
  private let viewModel = TeamsViewModel()
  private var teams: [Team] = []
  
  private var cancellables = Set<AnyCancellable>()
  
  enum Section {
    case main
  }
  
  private lazy var dataSource: UITableViewDiffableDataSource<Section, Team> = {
    return .init(tableView: tableView) { [weak self] tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TeamCell.identifier,
        for: indexPath) as? TeamCell ?? TeamCell()
      cell.accessoryType = .disclosureIndicator
      let teams = self?.teams ?? []
      cell.configure(team: teams[indexPath.item])
      return cell
    }
  }()
  
  override func loadView() {
    super.loadView()
    observe()
    setupView()
    setupTableView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewDidLoadSubject.send()
  }
  
  private func setupView() {
    view.backgroundColor = .white
    navigationItem.title = "Teams"
  }
  
  private func setupTableView() {
    tableView.register(TeamCell.self, forCellReuseIdentifier: TeamCell.identifier)
  }
  
  private func observe() {
    let input = TeamsViewModel.Input(
      viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
      teamDidSelect: teamDidSelectSubject.eraseToAnyPublisher())
    let output = viewModel.transform(input: input)
    output
      .setDataSource
      .receive(on: DispatchQueue.main)
      .sink { completion in
      if case .failure(let error) = completion {
        print(error)
      }
    } receiveValue: { [weak self] teams in
      self?.teams = teams
      self?.applySnapshot()
    }.store(in: &cancellables)
    output
      .showTeamDetail
      .receive(on: DispatchQueue.main)
      .sink { [weak self] team in
        let detailController = TeamDetailController(
          viewModel: TeamDetailViewModel(team: team))
        self?.navigationController?.pushViewController(
          detailController,
          animated: true)
      }.store(in: &cancellables)
  }
  
  private func applySnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Team>()
    snapshot.appendSections([.main])
    snapshot.appendItems(teams)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let team = dataSource.itemIdentifier(for: indexPath) else { return }
    teamDidSelectSubject.send(team)
  }
}
