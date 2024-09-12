//
//  SceneDelegate.swift
//  WeatherApp-CGD
//
//  Created by Django on 9/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        let nc = UINavigationController(rootViewController: WeatherViewController())
        window?.rootViewController = nc
    }

}

