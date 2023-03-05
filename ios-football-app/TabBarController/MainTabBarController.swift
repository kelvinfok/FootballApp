//
//  ViewController.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 1/3/23.
//

import UIKit

final class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupControllers()
  }
  
  private func setupControllers() {
    viewControllers = [
      buildMatchesController(),
      buildTeamsController()
    ]
  }
  
  private func buildMatchesController() -> UIViewController {
    return buildController(
      controller: MatchListController(),
      title: "Matches",
      image: .init(systemName: "sportscourt"))
  }
  
  private func buildTeamsController() -> UIViewController {
    return buildController(
      controller: TeamListController(),
      title: "Teams",
      image: .init(systemName: "person.3.fill"))
  }
  
  private func buildController(controller: UIViewController, title: String, image: UIImage?) -> UIViewController {
    let item = UITabBarItem(
      title: title,
      image: image,
      selectedImage: nil)
    controller.tabBarItem = item
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.navigationBar.prefersLargeTitles = true
    return navigationController
  }
}
