//
//  SceneDelegate.swift
//  ios-football-app
//
//  Created by Kelvin Fok on 1/3/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: scene)
    window.makeKeyAndVisible()
    window.rootViewController = MainTabBarController()
    self.window = window
  }
}
