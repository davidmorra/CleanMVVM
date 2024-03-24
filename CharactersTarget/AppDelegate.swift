//
//  AppDelegate.swift
//  CharactersTarget
//
//  Created by Davit on 19.03.24.
//

import UIKit
import Presentation
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let apiClient = ApiClient()
        let factory = CharacteresDIContainer(apiClient: apiClient)
        let navigationController = UINavigationController()
        let flow = CharactersFlowCoordinator(navigationController: navigationController, factory: factory)
        flow.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        setupNavigationAppearance()
        
        return true
    }
    
    private func setupNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
}

