//
//  SceneDelegate.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var firstTimeLaunch: Bool = true

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        ReachabilityManager.shared.observeNetworkState(observer: self)
    }
}

extension SceneDelegate: NetworkStateObservable {
    func didUpdateNetworkState(_ isConnected: Bool) {
        if firstTimeLaunch {
            firstTimeLaunch = false
            let navigationController = UINavigationController(rootViewController: CustomTabbarController())
            navigationController.navigationBar.isHidden = true
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
}
