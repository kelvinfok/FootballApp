//
//  TeamCell.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import UIKit

final class TeamCell: UITableViewCell {
  
  private enum Constant {
    static let nameLabelFontSize: CGFloat = 18
    static let stackViewSpacing: CGFloat = 16
    static let padding: CGFloat = 16
    static let logoImageViewHeight: CGFloat = 56
  }
  
  static let identifier = String(describing: TeamCell.self)
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: Constant.nameLabelFontSize, weight: .semibold)
    label.textAlignment = .center
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      logoImageView,
      nameLabel
    ])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = Constant.stackViewSpacing
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
  
  func configure(team: Team) {
    logoImageView.sd_setImage(
      with: URL(string: team.logo),
      placeholderImage: .init(systemName: "star.circle"))
    nameLabel.text = team.name
  }
  
  private func layout() {
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.padding),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.padding),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
      logoImageView.heightAnchor.constraint(equalToConstant: Constant.logoImageViewHeight),
      logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor)
    ])
  }
}
