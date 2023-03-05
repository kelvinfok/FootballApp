//
//  DateView.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 3/3/23.
//

import UIKit

class DateView: UIView {
  
  private enum Constant {
    static let dateLabelFontSize: CGFloat = 14
    static let timeLabelFontSize: CGFloat = 12
    static let stackViewSpacing: CGFloat = 4
  }
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(
      ofSize: Constant.dateLabelFontSize,
      weight: .bold)
    label.textAlignment = .center
    return label
  }()
  
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(
      ofSize: Constant.timeLabelFontSize,
      weight: .regular)
    label.textColor = .gray
    label.textAlignment = .center
    return label
  }()
  
  private let topSpacer = UIView()
  private let bottomSpacer = UIView()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      topSpacer,
      dateLabel,
      timeLabel,
      bottomSpacer
    ])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = Constant.stackViewSpacing
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
  
  func configure(date: Date?) {
    guard let date = date else {
      dateLabel.text = "N/A"
      timeLabel.text = "N/A"
      return }
    dateLabel.text = date.formatted(date: .abbreviated, time: .omitted)
    timeLabel.text = date.formatted(date: .omitted, time: .shortened)
  }
  
  private func layout() {
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor)
    ])
  }
}
