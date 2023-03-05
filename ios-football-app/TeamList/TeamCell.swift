//
//  TeamCell.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import UIKit

final class TeamCell: UITableViewCell {
  
  static let identifier = String(describing: TeamCell.self)
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18, weight: .semibold)
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
    stackView.spacing = 16
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
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      logoImageView.heightAnchor.constraint(equalToConstant: 56),
      logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor)
    ])
  }
}
