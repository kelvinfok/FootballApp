//
//  TeamStatsCell.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 4/3/23.
//

import UIKit

class TeamStatsCell: UITableViewCell {
  
  private enum Constant {
    static let descriptionLabelFontSize: CGFloat = 16
    static let dateLabelFontSize: CGFloat = 12
    static let resultLabelFontSize: CGFloat = 12
    static let stackViewSpacing: CGFloat = 8
    static let padding: CGFloat = 16
  }
  
  static let identifier = String(describing: TeamStatsCell.self)
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(
      ofSize: Constant.descriptionLabelFontSize,
      weight: .light)
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(
      ofSize: Constant.dateLabelFontSize,
      weight: .regular)
    label.textColor = .gray
    return label
  }()
  
  private let resultLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(
      ofSize: Constant.resultLabelFontSize,
      weight: .bold)
    label.textColor = .darkText
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      descriptionLabel,
      dateLabel,
      resultLabel
    ])
    stackView.spacing = Constant.stackViewSpacing
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
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.padding),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.padding),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding)
    ])
  }
}
