//
//  TeamView.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import UIKit

class TeamView: UIView {
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    label.numberOfLines = 2
    label.minimumScaleFactor = 0.5
    label.adjustsFontSizeToFitWidth = true
    label.textAlignment = .center
    return label
  }()
  
  private let crownImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "crown")?
      .withTintColor(UIColor(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1),
                     renderingMode: .alwaysTemplate)
      .addImagePadding(x: 8, y: 8)
    imageView.backgroundColor = .white
    imageView.layer.cornerRadius = 12
    return imageView
  }()
  
  private let topSpacer = UIView()
  private let bottomSpacer = UIView()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      topSpacer,
      crownImageView,
      imageView,
      nameLabel,
      bottomSpacer
    ])
    stackView.spacing = 4
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(name: String,
                 imageURL: String?,
                 placeholderImage: UIImage? = .init(systemName: "figure.soccer"),
                 isWinner: Bool) {
    nameLabel.text = name
    imageView.sd_setImage(
      with: URL(string: imageURL ?? ""),
      placeholderImage: placeholderImage)
    crownImageView.isHidden = !isWinner
  }
  
  private func layout() {
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 24),
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
      topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor),
      crownImageView.heightAnchor.constraint(equalToConstant: 24),
      crownImageView.widthAnchor.constraint(equalTo: crownImageView.heightAnchor)
    ])
  }
}
