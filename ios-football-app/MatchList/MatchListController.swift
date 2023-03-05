//
//  MatchesTableViewController.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 1/3/23.
//

import UIKit
import Combine
import SDWebImage
import AVKit

class MatchListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  private enum Constant {
    static let sectionHorizontalPadding: CGFloat = 32
  }
  
  private lazy var searchController: UISearchController = {
    let controller = UISearchController(searchResultsController: nil)
    controller.delegate = self
    controller.searchResultsUpdater = self
    controller.searchBar.autocapitalizationType = .none
    controller.obscuresBackgroundDuringPresentation = false
    var scopes: [String] = FilterScope.allCases.map { $0.stringValue.capitalized }
    controller.searchBar.scopeButtonTitles = scopes
    controller.searchBar.showsScopeBar = true
    controller.searchBar.delegate = self
    controller.searchBar.keyboardType = .alphabet
    controller.searchBar.autocorrectionType = .no
    controller.searchBar.autocapitalizationType = .none
    return controller
  }()
  
  private let vm = MatchListViewModel()
  private let outputSubject = PassthroughSubject<MatchListViewModel.Input, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  enum Section {
    case main
  }
    
  private lazy var dataSource: UICollectionViewDiffableDataSource<Section, MatchCell.Model> = {
    return .init(
      collectionView: collectionView) { collectionView, indexPath, model in
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: MatchCell.identifier,
          for: indexPath) as? MatchCell ?? MatchCell()
        cell.configure(model: model)
        return cell
      }
  }()
  
  private var models: [MatchCell.Model] = []
  
  init() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 8
    super.init(collectionViewLayout: layout)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
     observe()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    outputSubject.send(.viewDidLoad)
    applySnapshot(animatingDifferences: false)
    setupViews()
    setupSearchController()
    setupCollectionView()
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    navigationItem.searchController = searchController
    navigationItem.title = "Matches"
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Videos"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  
  private func setupCollectionView() {
    collectionView.register(MatchCell.self, forCellWithReuseIdentifier: MatchCell.identifier)
  }
    
  private func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, MatchCell.Model>()
    snapshot.appendSections([.main])
    snapshot.appendItems(models)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
  private func observe() {
    vm.transform(input: outputSubject.eraseToAnyPublisher())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] event in
        switch event {
        case .displayMatches(let models):
          self?.models = models
          self?.applySnapshot()
        case .openVideoPlayer(let url):
          self?.handleOpenVideoPlayer(url: url)
        }
      }.store(in: &cancellables)
  }
  
  private func handleOpenVideoPlayer(url: URL) {
    let player = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    present(playerViewController, animated: true, completion: {
      playerViewController.player?.play()
    })
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let model = dataSource.itemIdentifier(for: indexPath) else { return }
    outputSubject.send(.cellDidTap(model))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: collectionView.frame.width - Constant.sectionHorizontalPadding, height: MatchCell.heightForView())
  }
}

extension MatchListController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text else { return }
    outputSubject.send(.search(query))
  }
  
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    guard let scope = FilterScope(rawValue: selectedScope) else { return }
    outputSubject.send(.scopeDidUpdate(scope))
  }
}
