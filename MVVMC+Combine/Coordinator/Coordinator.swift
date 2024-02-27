//
//  Coordinator.swift
//  MVVMC+Combine
//
//  Created by Davit on 13.02.24.
//

import UIKit

protocol Coordinator {
    var parrentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var parrentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let followersVC = CharactersViewController()
        navigationController.pushViewController(followersVC, animated: true)
    }
}
