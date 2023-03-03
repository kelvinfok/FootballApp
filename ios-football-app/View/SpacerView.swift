//
//  Spacer.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 1/3/23.
//

import UIKit

class SpacerView: UIView {
  
  init(height: CGFloat) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: height)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
