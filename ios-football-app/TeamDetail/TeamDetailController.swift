//
//  TeamDetailController.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 4/3/23.
//

import UIKit
import Combine
import AVKit

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
      case .openVideoPlayer(let url):
        self?.handleOpenVideoPlayer(url: url)
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
  
  private func handleOpenVideoPlayer(url: URL) {
    let player = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    present(playerViewController, animated: true, completion: {
      playerViewController.player?.play()
    })
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let match = dataSource.itemIdentifier(for: indexPath) else { return }
    viewModel.onMatchDidSelect(match: match)
  }
}
