//
//  MatchCollectionViewCell.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import UIKit

class MatchCell: UICollectionViewCell {
  
  static let identifier = String(describing: MatchCell.self)

  private enum Constant {
    static let padding: CGFloat = 16
    static let cornerRadius: CGFloat = 8
  }
  
  struct Model: Hashable {
    let match: Match
    let homeTeamImageURL: String?
    let awayTeamImageURL: String?
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let homeTeamView = TeamView()
  private let awayTeamView = TeamView()
  private let dateView = DateView()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      homeTeamView,
      dateView,
      awayTeamView
    ])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 16
    stackView.distribution = .fillEqually
    stackView.axis = .horizontal
    return stackView
  }()
  
  private func layout() {
    contentView.backgroundColor = .systemGray6
    contentView.layer.cornerRadius = Constant.cornerRadius
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.padding),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.padding),
    ])
  }
  
  func configure(model: MatchCell.Model) {
    dateView.configure(date: MatchHelper.formatDate(dateString: model.match.date))
    let winner = MatchHelper.checkWinner(match: model.match)
    homeTeamView.configure(name: model.match.home, imageURL: model.homeTeamImageURL, isWinner: winner == .home)
    awayTeamView.configure(name: model.match.away, imageURL: model.awayTeamImageURL, isWinner: winner == .away)
  }
  
  class func heightForView() -> CGFloat {
    return 148
  }
}
