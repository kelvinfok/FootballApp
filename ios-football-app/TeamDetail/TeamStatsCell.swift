//
//  TeamStatsCell.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 4/3/23.
//

import UIKit

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
