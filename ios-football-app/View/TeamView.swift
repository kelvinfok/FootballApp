//
//  TeamView.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import UIKit

class TeamView: UIView {
  
  private enum Constant {
    static let nameLabelFontSize: CGFloat = 14
    static let stackViewSpacing: CGFloat = 4
    static let imageViewTintColor: UIColor = .init(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
    static let imageViewHeight: CGFloat = 24
    static let imageViewPadding: CGFloat = 8
    static let crownImageViewHeight: CGFloat = 24
    static let crownImageViewCornerRadius: CGFloat = 12
  }
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(
      ofSize: Constant.nameLabelFontSize,
      weight: .semibold)
    label.numberOfLines = 2
    label.minimumScaleFactor = 0.5
    label.adjustsFontSizeToFitWidth = true
    label.textAlignment = .center
    return label
  }()
  
  private let crownImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "crown")?
      .withTintColor(Constant.imageViewTintColor,
                     renderingMode: .alwaysTemplate)
      .addImagePadding(x: Constant.imageViewPadding, y: Constant.imageViewPadding)
    imageView.backgroundColor = .white
    imageView.layer.cornerRadius = Constant.crownImageViewCornerRadius
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
    stackView.spacing = Constant.stackViewSpacing
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
      imageView.heightAnchor.constraint(equalToConstant: Constant.imageViewHeight),
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
      topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor),
      crownImageView.heightAnchor.constraint(equalToConstant: Constant.crownImageViewHeight),
      crownImageView.widthAnchor.constraint(equalTo: crownImageView.heightAnchor)
    ])
  }
}
